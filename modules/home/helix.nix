{ lib, pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      # html, css
      vscode-langservers-extracted

      # javascript
      deno
      nodePackages.prettier
      nodePackages.typescript-language-server
      prettierd
      vscode-langservers-extracted

      # nix
      nil
      nixd
      nixfmt-rfc-style

      # python
      pyright
      ruff
    ];

    settings.editor = {
      popup-border = "all";
      line-number = "relative";
      mouse = false;
      continue-comments = false;
      true-color = true;
      default-yank-register = "+";
      default-line-ending = "lf";
      scrolloff = 50;
      color-modes = true;
      soft-wrap.enable = true;

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

    settings.keys = {
      normal = {
        A-h = "jump_backward";
        A-l = "jump_forward";
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
          # lazygit
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
        home = "goto_first_nonwhitespace";
        end = "goto_line_end";
      };

      insert = {
        C-h = "move_char_left";
        C-l = "move_char_right";
        C-k = "move_line_up";
        C-j = "move_line_down";
        C-space = "completion";
      };
    };

    languages.language-server = {
      emmet-lsp = {
        command = lib.getExe pkgs.emmet-ls;
        args = [ "--stdio" ];
      };
      eslint = {
        command = "${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server";
        args = [ "--stdio" ];
        config = {
          validate = "on";
          experimental.useFlatConfig = false;
          run = "onType";
          problems.shortenToSingleLine = false;
          codeAction.disableRuleComment = {
            enable = true;
            location = "separateLine";
          };
          codeActionOnSave = {
            enable = true;
            mode = "fixAll";
          };
          workingDirectory.mode = "location";
        };
      };
      gopls = {
        command = lib.getExe pkgs.gopls;
        config = {
          gofumpt = true;
        };
      };
      nixd = {
        command = lib.getExe pkgs.nixd;
        config.nixd = {
          formatting.command = "nixfmt";
          options = {
            nixpkgs.expr = "import <nixpkgs> {}";
          };
        };
      };
      typescript-language-server = {
        command = lib.getExe pkgs.nodePackages.typescript-language-server;
        args = [ "--stdio" ];
      };
    };

    languages.language =
      let
        denoFormatter = language: {
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
            (name: {
              inherit name;
              auto-format = true;
              formatter = denoFormatter name;
            })
            [
              "html"
              "css"
              "scss"
              "json"
              "yaml"
              "markdown"
            ];
      in
      [
        {
          name = "python";
          auto-format = true;
          formatter = {
            command = "ruff";
            args = [
              "format"
              "--line-length"
              "88"
              "-"
            ];
          };
          language-servers = [
            "pyright"
            "ruff"
          ];
        }
        {
          name = "javascript";
          auto-format = true;
          formatter = denoFormatter "js";
          language-servers = [
            "eslint"
            "typescript-language-server"
          ];
        }
        {
          name = "jsx";
          auto-format = true;
          formatter = denoFormatter "jsx";
          language-servers = [
            "eslint"
            "emmet-lsp"
            "typescript-language-server"
          ];
        }
        {
          name = "typescript";
          auto-format = true;
          formatter = denoFormatter "ts";
          language-servers = [
            "eslint"
            "typescript-language-server"
          ];
        }
        {
          name = "tsx";
          auto-format = true;
          formatter = denoFormatter "tsx";
          language-servers = [
            "eslint"
            "emmet-lsp"
            "typescript-language-server"
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
        {
          name = "go";
          auto-format = true;
          formatter.command = "gofumpt";
          language-servers = [ "gopls" ];
        }
      ]
      ++ denoLanguages;

    settings.theme = "forest";

    themes.forest = {
      inherits = "amberwood";
      "ui.background" = { };
      "ui.menu" = { };
      "ui.popup" = { };
      "ui.statusline" = { };
      "ui.window" = { };
      "ui.help" = { };
    };
  };
}
