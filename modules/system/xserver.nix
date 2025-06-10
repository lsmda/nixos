{ pkgs, ... }:

{
  services = {
    displayManager.defaultSession = "niri";

    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
      };
    };

    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      excludePackages = [ pkgs.xterm ];
    };

    printing.enable = false;
    gnome.core-apps.enable = false;

    # required to run systray icons
    udev.packages = [ pkgs.gnome-settings-daemon ];
  };

  programs.geary.enable = false;
  documentation.nixos.enable = false;
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];
}
