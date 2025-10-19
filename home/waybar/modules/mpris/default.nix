{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      playerctl # mpris support
    ];

    programs.waybar = {
      settings.main = {
        mpris = {
          format = "{player_icon} {title}";
          format-paused = "{status_icon} {title}";
          tooltip-format = "Playing: {title}";
          tooltip-format-paused = "Paused: {title}";
          player-icons = {
            default = "󰏤";
          };
          status-icons = {
            paused = "󰐊";
          };
          max-length = 30;
        };
      };
      style = ''
        #mpris {
        	margin: 0 4px;
        	padding: 0 10px;
        }
      '';
    };
  };
}
