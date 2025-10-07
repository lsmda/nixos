{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      bluez # bluetoothctl
    ];

    programs.waybar = {
      settings.main = {
        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-off = "󰂲";
          format-on = "󰂰";
          format-connected = "󰂱";
          min-length = 2;
          max-length = 2;
          on-click = "blueman-manager";
          on-click-right = "bluetoothctl power off && notify-send 'Bluetooth Off' -i 'network-bluetooth-inactive' -r 1925";
          tooltip-format = "Device Addr: {device_address}";
          tooltip-format-disabled = "Bluetooth Disabled";
          tooltip-format-off = "Bluetooth Off";
          tooltip-format-on = "Bluetooth Disconnected";
          tooltip-format-connected = "Device: {device_alias}";
          tooltip-format-enumerate-connected = "Device: {device_alias}";
          tooltip-format-connected-battery = "Device: {device_alias}\nBattery: {device_battery_percentage}%";
          tooltip-format-enumerate-connected-battery = "Device: {device_alias}\nBattery: {device_battery_percentage}%";
        };
      };
      style = ''
        #bluetooth {
        	background-color: @tray;
        	padding: 0 5px;
        }
      '';
    };
  };
}
