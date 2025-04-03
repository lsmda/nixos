{ pkgs, ... }:

{
  hardware.bluetooth.enable = true;

  hardware.bluetooth.package = pkgs.bluez;
  hardware.bluetooth.powerOnBoot = true;

  # prevents airpods from being stolen back by bluez
  hardware.bluetooth.settings.Policy.ReconnectAttempts = 0;

  hardware.bluetooth.settings.General.Enable = "Source,Sink,Media,Socket";
  hardware.bluetooth.settings.General.Experimental = true;
  hardware.bluetooth.settings.General.ControllerMode = "bredr";

  services.blueman.enable = true;
}
