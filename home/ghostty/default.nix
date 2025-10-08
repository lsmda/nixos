{
  config = {
    programs.ghostty = {
      enable = true;
      settings = {
        font-size = 14;
        theme = "iceberg-dark";

        font-family = "Berkeley Mono"; # "JetBrains Mono"

        background-blur = true;
        background-opacity = 0.95;

        clipboard-paste-protection = true;
        clipboard-trim-trailing-spaces = true;

        window-inherit-working-directory = true;
        window-padding-x = 6;
        window-padding-y = 6;
        window-padding-balance = true;
        window-padding-color = "background";

        cursor-style = "block";
        cursor-style-blink = false;
        cursor-invert-fg-bg = true;

        shell-integration-features = "no-cursor";

        mouse-hide-while-typing = true;

        scrollback-limit = 9999999;

        font-feature = [
          "+liga"
          "+ss01"
          "+ss02"
        ];

        adjust-box-thickness = 1;
        adjust-cursor-thickness = 1;

        resize-overlay = "never";
        copy-on-select = false;
        confirm-close-surface = false;

        keybind = [
          "shift+alt+enter=new_tab"
          "shift+alt+backspace=close_tab"
          "shift+alt+h=previous_tab"
          "shift+alt+l=next_tab"
          "ctrl+shift+r=reload_config"
        ];
      };
    };
  };
}
