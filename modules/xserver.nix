{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  environment.variables = {
    NIXOS_OZONE_WL = "1"; # use wayland on electron apps
  };

  xdg.portal.enable = true;
  xdg.portal.config.common.default = "*";
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-hyprland
  ];

  # secrets credential store (git, etc)
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.libinput.enable = true;
  services.libinput.touchpad.naturalScrolling = true;
  services.libinput.touchpad.disableWhileTyping = true;

  services.printing.enable = false;
  documentation.nixos.enable = false;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # virtual box
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ config.machine.username ];
}
