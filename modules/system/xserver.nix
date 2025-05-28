{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    excludePackages = [ pkgs.xterm ];
  };

  services.displayManager.defaultSession = "gnome-xorg";

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
    touchpad.disableWhileTyping = true;
  };

  # required to run systray icons
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  services.printing.enable = false;
  services.gnome.core-apps.enable = false;
  programs.geary.enable = false;
  documentation.nixos.enable = false;
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # virtual box
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ config.machine.username ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };
}
