{ pkgs, ... }:

{
  hardware.bluetooth.enable = true;

  hardware.bluetooth.package = pkgs.bluez;
  hardware.bluetooth.powerOnBoot = true;

  # prevents airpods being stolen back by bluez 
  hardware.bluetooth.settings.Policy.ReconnectAttempts = 0;

  hardware.bluetooth.settings.General = {
    Enable = "Source,Sink,Media,Socket";
    Experimental = true;
    ControllerMode = "bredr";
  };

  services.blueman.enable = true;
}
