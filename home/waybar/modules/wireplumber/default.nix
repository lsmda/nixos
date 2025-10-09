{
  config.programs.waybar.settings.main = {
    "group/wireplumber" = {
      orientation = "horizontal";
      modules = [
        "wireplumber#output"
        "wireplumber#input"
      ];
    };

    "wireplumber#output" = {
      format = "{icon} {volume}%";
      format-muted = "󰝟 {volume}%";
      format-icons = [
        "󰕿"
        "󰖀"
        "󰕾"
      ];
      min-length = 7;
      max-length = 7;
      on-click = "swayosd-client --output-volume mute-toggle";
      on-scroll-up = "swayosd-client --output-volume +1";
      on-scroll-down = "swayosd-client --output-volume -1";
      tooltip-format = "Device: {node_name}";
      node-type = "Audio/Sink";
    };

    "wireplumber#input" = {
      format = "󰍬 {volume}%";
      format-muted = "󰍭 {volume}%";
      min-length = 7;
      max-length = 7;
      on-click = "swayosd-client --input-volume mute-toggle";
      on-scroll-up = "swayosd-client --input-volume +1";
      on-scroll-down = "swayosd-client --input-volume -1";
      tooltip-format = "Device: {node_name}";
      node-type = "Audio/Source";
    };
  };
}
