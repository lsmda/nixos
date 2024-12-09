{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  services.gnome.core-utilities.enable = false;

  services.printing.enable = true;

  # required to run systray icons
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  services.xserver.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  # remove pre-installed gnome apps
  documentation.nixos.enable = false;
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];
  services.xserver.excludePackages = [ pkgs.xterm ];

  # virtual box
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ config.machine.username ];
}
