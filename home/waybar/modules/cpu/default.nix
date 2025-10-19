{
  config.programs.waybar.settings.main = {
    cpu = {
      interval = 2;
      format = " {usage}%";
      format-warning = "󰀨 {usage}%";
      format-critical = "󰀨 {usage}%";
      min-length = 6;
      max-length = 6;
      states = {
        warning = 75;
        critical = 90;
      };
      tooltip = false;
    };
  };
}
