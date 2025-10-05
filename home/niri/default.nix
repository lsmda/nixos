{
  config,
  lib,
  pkgs,
  ...
}:

let
  default = builtins.readFile ./configuration/default.kdl;
  hostname = builtins.readFile ./configuration/${config.machine.hostname}.kdl;
in

{
  home.file.".config/niri/config.kdl".text = lib.strings.concatStringsSep "" [
    default
    hostname
  ];

  home.packages = with pkgs; [
    wayland
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    qt5.qtwayland # for qt

    wtype # xdotool, but for wayland
    xwayland
    # kdePackages.xwaylandvideobridge # Portal for screen sharing

    # A cool app to test a DE for which portals it support
    # https://flathub.org/apps/com.belmoussaoui.ashpd.demo
    ashpd-demo
  ];
}
