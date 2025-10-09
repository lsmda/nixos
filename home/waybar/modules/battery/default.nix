{
  config = {
    programs.waybar = {
      settings.main = {
        battery = {
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{icon} {capacity}%";
          format-time = "{H} hr {M} min";
          format-icons = [
            "󰂎"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format-charging = "󰉁 {capacity}%";
          min-length = 7;
          max-length = 7;
          tooltip-format = "Discharging: {time}";
          tooltip-format-charging = "Charging: {time}";
          events = {
            on-discharging-warning = "notify-send 'Low Battery' '{capacity}% battery remaining'";
            on-discharging-critical = "notify-send 'Low Battery' '{capacity}% battery remaining' -u critical";
            on-charging-100 = "notify-send 'Battery full' 'Battery is at {capacity}%'";
          };
        };
      };
    };
  };
}
