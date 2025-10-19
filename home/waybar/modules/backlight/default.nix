{
  config.programs.waybar.settings.main = {
    backlight = {
      format = "{icon} {percent}%";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
      ];
      min-length = 7;
      max-length = 7;
      on-scroll-up = "swayosd-client --brightness -1";
      on-scroll-down = "swayosd-client --brightness +1";
      tooltip = false;
    };
  };
}
