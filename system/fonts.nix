{ pkgs, ... }:

let
  charter = pkgs.callPackage ../packages/charter.nix { };
  consolas = pkgs.callPackage ../packages/consolas.nix { };
  __corefonts = pkgs.callPackage ../packages/corefonts/package.nix { };
in

{
  config = {
    environment.sessionVariables.FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";

    fonts.packages = with pkgs; [
      __corefonts

      #sans
      open-sans
      noto-fonts-emoji

      # serif
      charter
      consolas

      # monospace
      jetbrains-mono
      nerd-fonts.symbols-only
    ];
  };
}
