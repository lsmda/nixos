{ pkgs, ... }:

{
  config = {
    environment.gnome.excludePackages = [ pkgs.gnome-tour ];

    programs.geary.enable = false;

    services = {
      displayManager.defaultSession = "gnome-xorg";

      xserver = {
        enable = true;
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
        excludePackages = [ pkgs.xterm ];
      };

      gnome.core-apps.enable = false;

      # required to run systray icons
      udev.packages = [ pkgs.gnome-settings-daemon ];
    };
  };
}
