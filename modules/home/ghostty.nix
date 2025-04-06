{
  programs.ghostty = {
    enable = true;

    settings = {
      font-size = 11;
      font-family = "JetBrainsMono Nerd Font";

      adjust-cell-width = "10%";
      adjust-cell-height = "5%";

      background-blur = true;
      background-opacity = 0.98;

      clipboard-paste-protection = true;
      clipboard-trim-trailing-spaces = true;

      theme = "Everforest Dark - Hard";

      window-inherit-working-directory = true;
      window-padding-x = 4;
      window-padding-y = 8;
      window-padding-balance = true;
      window-padding-color = "background";

      cursor-style = "block";
      cursor-style-blink = false;
      cursor-invert-fg-bg = true;

      shell-integration-features = "no-cursor";

      mouse-hide-while-typing = true;

      scrollback-limit = 9999999;

      font-feature = [
        "ss01"
        "ss04"
      ];

      adjust-box-thickness = 1;
      adjust-cursor-thickness = 1;

      resize-overlay = "never";
      copy-on-select = false;
      confirm-close-surface = false;

      gtk-single-instance = false;

      term = "ghostty";

      keybind = [
        "shift+alt+enter=new_tab"
        "shift+alt+backspace=close_tab"
        "shift+alt+h=previous_tab"
        "shift+alt+l=next_tab"
        "ctrl+shift+r=reload_config"
      ];
    };
  };
}
