{ pkgs, ... }:

{
  config = {
    programs.dconf.enable = true;
    programs.niri.enable = true;
    programs.xwayland.enable = true;

    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
      ];
      config.common = {
        default = "gnome";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
      };
    };
  };
}
