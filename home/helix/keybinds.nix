{ pkgs, ... }:

let
  blame_line = pkgs.writeShellScript "blame_line" builtins.readFile ./scripts/blame_line.sh;
  blame_file = pkgs.writeShellScript "blame_file" builtins.readFile ./scripts/blame_file.sh;
  git_hunk = pkgs.writeShellScript "git_hunk" builtins.readFile ./scripts/git_hunk.sh;
in

{
  config.programs.helix.settings.keys = {
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
        ret = "goto_word";

        # lazygit
        l = [
          ":write-all"
          ":new"
          ":insert-output lazygit"
          ":buffer-close!"
          ":redraw"
          ":reload-all"
        ];

        space = [
          ":sh rm -f /tmp/hx-yazi-picker"
          ":insert-output yazi %{buffer_name} --chooser-file=/tmp/hx-yazi-picker"
          ":insert-output echo '\x1b[?1049h\x1b[?2004h' > /dev/tty"
          # Doesn't support opening multiple files.
          ":open %sh{cat /tmp/hx-yazi-picker | head -n1}"
          ":redraw"
          ":set mouse false"
          ":set mouse true"
        ];

        b = ":run-shell-command ${blame_line} %{buffer_name} %{cursor_line}";
        g = ":open %sh{${blame_file} %{buffer_name} %{cursor_line}}";
        h = ":run-shell-command ${git_hunk} %{buffer_name} %{cursor_line} 3";

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
        t = {
          s = ":toggle-option soft-wrap.enable";
          u = "switch_case";
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
}
