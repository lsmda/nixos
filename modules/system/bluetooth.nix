{ pkgs, ... }:

{
  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;

    package = pkgs.bluez;
    powerOnBoot = true;

    # prevents airpods from being stolen back by bluez
    settings.Policy.ReconnectAttempts = 0;

    settings.General.Enable = "Source,Sink,Media,Socket";
    settings.General.Experimental = true;
    settings.General.ControllerMode = "bredr";
  };
}
