{
  config = {
    programs.waybar = {
      settings.main = {
        "group/pulseaudio" = {
          orientation = "horizontal";
          modules = [
            "pulseaudio#output"
            "pulseaudio#input"
          ];
          drawer = {
            transition-left-to-right = false;
          };
        };

        "pulseaudio#output" = {
          format = "{icon} {volume}%";
          format-muted = "{icon} {volume}%";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
            default-muted = "󰝟";
            headphone = "󰋋";
            headphone-muted = "󰟎";
            headset = "󰋎";
            headset-muted = "󰋐";
          };
          min-length = 7;
          max-length = 7;
          on-click = "swayosd-client --output-volume mute-toggle";
          on-scroll-up = "swayosd-client --output-volume +2";
          on-scroll-down = "swayosd-client --output-volume -2";
          tooltip-format = "Output Device: {desc}";
        };

        "pulseaudio#input" = {
          format = "{format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭 {volume}%";
          min-length = 7;
          max-length = 7;
          on-click = "swayosd-client --input-volume mute-toggle";
          on-scroll-up = "swayosd-client --input-volume +2";
          on-scroll-down = "swayosd-client --input-volume -2";
          tooltip-format = "Input Device: {desc}";
        };
      };
    };
  };
}
