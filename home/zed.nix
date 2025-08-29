{
  config = {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "angular"
        "base16"
        "live-server"
        "scss"
      ];
      userKeymaps = [
        {
          "bindings" = {
            "alt-left" = "pane::GoBack";
            "alt-right" = "pane::GoForward";
            "alt-w" = "workspace::ToggleBottomDock";
            "ctrl-e" = "workspace::ToggleRightDock";
            "ctrl-shift-e" = "project_panel::Open";
            "ctrl-shift-g" = "git_panel::OpenMenu";
            "ctrl-shift-x" = "zed::Extensions";
          };
        }
        {
          "context" = "Editor";
          "bindings" = {
            "shift-alt-down" = "editor::DuplicateLineDown";
            "shift-alt-up" = "editor::DuplicateLineUp";
          };
        }
      ];
      userSettings = {
        "ui_font_size" = 20;
        "buffer_font_size" = 18;
        "theme" = {
          "mode" = "system";
          "light" = "Base16 Gruvbox Material Light, Soft";
          "dark" = "Base16 Gruvbox Material Dark, Hard";
        };
        "base_keymap" = "VSCode";
        "cursor_shape" = "block";
        "toolbar" = {
          "breadcrumbs" = false;
          "quick_actions" = false;
        };
        "indent_guides" = {
          "enabled" = false;
        };
        "project_panel" = {
          "button" = false;
          "dock" = "right";
          "indent_guides" = {
            "show" = "never";
          };
        };
        "outline_panel" = {
          "button" = true;
          "dock" = "right";
        };
        "collaboration_panel" = {
          "button" = false;
        };
        "chat_panel" = {
          "button" = "never";
          "dock" = "right";
        };
        "git_panel" = {
          "button" = false;
          "dock" = "right";
        };
        "tab_bar" = {
          "show_nav_history_buttons" = false;
          "show_tab_bar_buttons" = false;
        };
        "extend_comment_on_newline" = false;
        "preferred_line_length" = 100;
        "tab_size" = 2;
      };
    };
  };
}
