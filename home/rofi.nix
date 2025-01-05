{ pkgs, ... }:

{
  rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    # plugins = with pkgs; [
    #   rofi-calc
    #   rofi-power-menu
    #   rofimoji
    #   rofi-vpn
    # ];
  };
}
