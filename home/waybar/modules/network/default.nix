{ pkgs, ... }:

let
  networkScript = pkgs.writeScript "network.sh" (builtins.readFile ./script.sh);
in

{
  config = {
    home.packages = with pkgs; [
      networkmanager # nmcli
    ];

    programs.waybar = {
      settings.main = {
        network = {
          interval = 10;
          format-disconnected = "󰤮";
          format-ethernet = "󰈀";
          format-wifi = "󰤨";
          format-icons = [
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          min-length = 2;
          max-length = 2;
          on-click = "ghostty -e ${networkScript}";
          on-click-right = "nmcli radio wifi off && notify-send 'Wi-Fi Disabled' -i 'network-wireless-off' -r 1125";
          tooltip-format = "Gateway: {gwaddr}";
          tooltip-format-ethernet = "Interface: {ifname}";
          tooltip-format-wifi = "Network: {essid}\nIP Addr: {ipaddr}/{cidr}\nStrength: {signalStrength}%\nFrequency: {frequency} GHz";
          tooltip-format-disconnected = "Wi-Fi Disconnected";
          tooltip-format-disabled = "Wi-Fi Disabled";
        };
      };
      style = ''
        #network {
        	padding: 0 6px 0 4px;
        }
      '';
    };
  };
}
