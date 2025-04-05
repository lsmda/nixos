{ lib, pkgs, ... }:

{
  programs.helix.enable = true;
  programs.helix.defaultEditor = true;
  programs.helix.settings.theme = "forest";

  programs.helix.extraPackages = with pkgs; [
    # html, css
    vscode-langservers-extracted

    # javascript
    deno
    nodePackages.prettier
    nodePackages.typescript-language-server
    prettierd

    # nix
    nil
    nixd
    nixfmt-rfc-style
  ];

  programs.helix.languages.language-server = {
    nixd = {
      command = "nixd";
      config.nixd = {
        formatting.command = "nixfmt";
        options = {
          nixpkgs.expr = "import <nixpkgs> {}";
          nixos.expr = "import <nixos> { configuration = /etc/nixos/configuration.nix; }";
        };
      };
    };
    typescript-language-server = with pkgs.nodePackages; {
      command = lib.getExe typescript-language-server;
      args = [ "--stdio" ];
    };
  };

  programs.helix.languages.language =
    let
      denoFmt = language: {
        command = "deno";
        args = [
          "fmt"
          "-"
          "--ext"
          language
        ];
      };

      denoLanguages =
        map
          (language: {
            name = language;
            auto-format = true;
            formatter = denoFmt language;
          })
          [
            "markdown"
            "json"
          ];

      prettierFmt = language: {
        command = "prettier";
        args = [
          "--parser"
          language
        ];
      };

      prettierLanguages =
        map
          (language: {
            name = language;
            auto-format = true;
            formatter = prettierFmt language;
          })
          [
            "html"
            "css"
            "scss"
            "yaml"
          ];
    in
    [
      {
        name = "javascript";
        auto-format = true;
        formatter = denoFmt "js";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
        ];
      }
      {
        name = "jsx";
        auto-format = true;
        formatter = denoFmt "jsx";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
        ];
      }
      {
        name = "typescript";
        auto-format = true;
        formatter = denoFmt "ts";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
        ];
      }
      {
        name = "tsx";
        auto-format = true;
        formatter = denoFmt "tsx";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
        ];
      }
      {
        name = "nix";
        auto-format = true;
        formatter.command = "nixfmt";
        language-servers = [
          "nil"
          "nixd"
        ];
      }
    ]
    ++ denoLanguages
    ++ prettierLanguages;

  programs.helix.settings.editor = {
    popup-border = "all";
    line-number = "relative";
    mouse = false;
    scrolloff = 50;
    color-modes = true;

    completion-replace = true;
    completion-timeout = 250;
    completion-trigger-len = 2;

    file-picker = {
      hidden = false;
    };

    indent-guides = {
      render = true;
      character = "╎";
      skip-levels = 2;
    };

    lsp = {
      enable = true;
      display-messages = true;
    };

    statusline = {
      left = [
        "mode"
        "file-name"
        "version-control"
        "file-modification-indicator"
      ];
      right = [
        "spinner"
        "diagnostics"
        "selections"
        "position"
        "file-encoding"
        "file-line-ending"
        "file-type"
      ];
      mode = {
        normal = "N";
        insert = "I";
        select = "S";
      };
    };
  };

  programs.helix.settings.keys = {
    normal = {
      A-h = "jump_backward";
      A-l = "jump_forward";
      A-q = "goto_first_nonwhitespace";
      A-e = "goto_line_end";
      A-j = [
        "extend_to_line_bounds"
        "delete_selection"
        "move_line_down"
        "paste_before"
      ];
      A-k = [
        "extend_to_line_bounds"
        "delete_selection"
        "move_line_up"
        "paste_before"
      ];
      A-S-j = [
        "extend_to_line_bounds"
        "yank"
        "paste_after"
      ];
      A-S-k = [
        "extend_to_line_bounds"
        "yank"
        "paste_before"
      ];
      C-a = "select_all";
      C-h = "jump_view_left";
      C-j = "jump_view_down";
      C-k = "jump_view_up";
      C-l = "jump_view_right";
      C-space = "expand_selection";
      backspace = "shrink_selection";
      esc = [
        "collapse_selection"
        "keep_primary_selection"
      ];
      ret = [
        "open_below"
        "normal_mode"
      ];
      space = {
        l = [
          ":write-all"
          ":new"
          ":insert-output lazygit"
          ":buffer-close!"
          ":redraw"
          ":reload-all"
        ];
        q = ":quit";
        Q = ":quit-all!";
        p = "paste_clipboard_before";
        r = {
          r = ":config-reload";
          n = "rename_symbol";
        };
        s = {
          j = ":hsplit";
          l = ":vsplit";
        };
        w = [
          ":fmt"
          ":write"
        ];
      };
    };

    insert = {
      C-h = "move_char_left";
      C-l = "move_char_right";
      C-k = "move_line_up";
      C-j = "move_line_down";
      C-space = "completion";
    };

    select = {
      A-n = "normal_mode";
      A-e = "extend_to_line_end";
      A-q = "extend_to_line_start";
    };
  };

  programs.helix.themes.forest = {
    inherits = "everforest_dark";
    "ui.background" = { };
    "ui.menu" = { };
    "ui.popup" = { };
    "ui.statusline" = { };
    "ui.window" = { };
    "ui.help" = { };
  };
}
