{ pkgs, ... }:

let
  volume_script = pkgs.writeScript "volume.sh" (builtins.readFile ./script.sh);
in

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
          on-click = "${volume_script} output mute";
          on-scroll-up = "${volume_script} output raise";
          on-scroll-down = "${volume_script} output lower";
          tooltip-format = "Output Device: {desc}";
        };

        "pulseaudio#input" = {
          format = "{format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭 {volume}%";
          min-length = 7;
          max-length = 7;
          on-click = "${volume_script} input mute";
          on-scroll-up = "${volume_script} input raise";
          on-scroll-down = "${volume_script} input lower";
          tooltip-format = "Input Device: {desc}";
        };
      };
      style = ''
        #custom-left_div.6 {
        	color: @volume;
        }
        #pulseaudio,
        #wireplumber {
        	background-color: @volume;
        }
      '';
    };
  };
}
