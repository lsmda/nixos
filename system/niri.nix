{ pkgs, ... }:

{
  config = {
    programs.niri.enable = true;
    programs.xwayland.enable = true;

    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;

    xdg.portal.enable = true;
    xdg.portal.xdgOpenUsePortal = true;
    # xdg.portal.config.common.default = "*";

    xdg.portal.wlr.enable = true;
    xdg.portal.extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-cosmic
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];

    xdg.portal.config.niri = {
      default = "gtk";
      "org.freedesktop.impl.portal.Secret" = [
        "kwallet"
      ];
    };
  };
}
