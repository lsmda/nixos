{ pkgs, ... }:

{
  config = {
    programs.niri.enable = true;
    programs.xwayland.enable = true;

    services.xserver.enable = false;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.gdm.wayland = true;

    xdg.portal.enable = true;
    xdg.portal.wlr.enable = true;
    xdg.portal.wlr.settings.screencast.max_fps = 60;

    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gnome
    ];

    xdg.portal.config.common = {
      default = [
        "wlr"
      ];
      "org.freedesktop.portal.ScreenCast" = "gnome"; # Frontend D-Bus interface to request access
      "org.freedesktop.impl.portal.ScreenCast" = "wlr"; # Backend interface for handling the actual casting
    };
  };
}
