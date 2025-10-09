{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      playerctl # mpris support
    ];

    programs.waybar = {
      settings.main = {
        mpris = {
          format = "{player_icon} {title} - {artist}";
          format-paused = "{status_icon} {title} - {artist}";
          tooltip-format = "Playing: {title} - {artist}";
          tooltip-format-paused = "Paused: {title} - {artist}";
          player-icons = {
            default = "󰏤";
          };
          status-icons = {
            paused = "󰐊";
          };
          max-length = 38;
        };
      };
      style = ''
        #mpris {
        	padding: 0 12px;
        	font-weight: normal;
        }
      '';
    };
  };
}
