{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # ts/js
    nodePackages.prettier
    prettierd

    # nix
    nil
    nixfmt-rfc-style
  ];

  programs.helix.enable = true;

  programs.helix.settings.editor = {
    completion-replace = true;
    popup-border = "all";
    line-number = "relative";
    mouse = false;
    scrolloff = 50;
    color-modes = true;
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
        "yank"
        "paste_after"
      ];
      A-S-k = [
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
    };
    select = {
      A-n = "normal_mode";
      A-e = "extend_to_line_end";
      A-q = "extend_to_line_start";
    };
  };

  programs.helix.languages.language =
    let
      __prettier = language: {
        command = lib.getExe pkgs.nodePackages.prettier;
        args = [
          "--parser"
          language
        ];
      };
      __prettierd = extension: {
        command = lib.getExe pkgs.prettierd;
        args = [ extension ];
      };
    in
    [
      {
        name = "html";
        auto-format = true;
        formatter = __prettier "html";
      }
      {
        name = "css";
        auto-format = true;
        formatter = __prettier "css";
      }
      {
        name = "javascript";
        auto-format = true;
        formatter = __prettierd ".js";
      }
      {
        name = "jsx";
        auto-format = true;
        formatter = __prettierd ".jsx";
      }
      {
        name = "typescript";
        auto-format = true;
        formatter = __prettierd ".ts";
      }
      {
        name = "tsx";
        auto-format = true;
        formatter = __prettierd ".tsx";
      }
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
      }
    ];

  programs.helix.settings.theme = "forest";

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
