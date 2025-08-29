{ pkgs, ... }:

{
  config = {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.sessionVariables.QT_QPA_PLATFORM = "wayland;xcb";
    environment.sessionVariables.XAUTHORITY = "$XDG_CONFIG_HOME/sddm/Xauthority";

    services.xserver.enable = false;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
      settings = {
        X11.UserAuthFile = ".local/share/sddm/Xauthority";
      };
    };

    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = [
      pkgs.kdePackages.elisa
      pkgs.kdePackages.xwaylandvideobridge
    ];

    programs.partition-manager.enable = true;
    programs.kdeconnect.enable = false;
    programs.kde-pim.enable = false;
  };
}
