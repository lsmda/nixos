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
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-wlr
      ];
      config.common.default = [
        "gnome" # Primary (file chooser, etc)
        "wlr" # Fallback (screencast)
      ];
    };
  };
}
