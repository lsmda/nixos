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

  # enable virtual box
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ config.machine.username ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };

  # run garbage collection whenever there is less than 500mb free space left
  nix.extraOptions = ''
    min-free = ${toString (500 * 1024 * 1024)}
  '';

  # maximum number of latest generations in the boot menu.
  boot.loader.systemd-boot.configurationLimit = 4;
}
