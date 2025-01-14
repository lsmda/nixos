{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  # required to run systray icons
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  # remove pre-installed gnome apps
  programs.geary.enable = false;
  documentation.nixos.enable = false;
  services.gnome.core-utilities.enable = false;
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];
  services.xserver.excludePackages = [ pkgs.xterm ];

  services.libinput.enable = true;
  services.libinput.touchpad.naturalScrolling = true;
  services.libinput.touchpad.disableWhileTyping = true;

  services.printing.enable = false;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # virtual box
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ config.machine.username ];
}
