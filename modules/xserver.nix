{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  services = {
    gnome.core-utilities.enable = false;

    printing.enable = true;

    # required to run systray icons
    udev.packages = with pkgs; [ gnome-settings-daemon ];

    xserver.enable = true;
    xserver.desktopManager.xterm.enable = false;
    xserver.desktopManager.gnome.enable = true;
    xserver.displayManager.gdm.enable = true;
  };

  # remove pre-installed gnome apps
  documentation.nixos.enable = false;
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];
  services.xserver.excludePackages = [ pkgs.xterm ];
}
