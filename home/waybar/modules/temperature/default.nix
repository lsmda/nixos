{
  config.programs.waybar.settings.main = {
    temperature = {
      thermal-zone = 1;
      critical-threshold = 90;
      interval = 2;
      format-critical = "󰀦 {temperatureC}°C";
      format = "{icon} {temperatureC}°C";
      format-icons = [
        "󱃃"
        "󰔏"
        "󱃂"
      ];
      min-length = 8;
      max-length = 8;
      tooltip-format = "Temp in Fahrenheit: {temperatureF}°F";
    };
  };
}
