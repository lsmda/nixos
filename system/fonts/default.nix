{ pkgs, ... }:

{
  imports = [
    ../../packages/berkeley-mono
    ../../packages/charter
    ../../packages/consolas
    ../../packages/corefonts
  ];

  config = {
    environment.sessionVariables.FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";

    fonts.packages = with pkgs; [
      # sans
      open-sans
      noto-fonts-emoji

      # monospace
      jetbrains-mono

      # symbols
      nerd-fonts.symbols-only
    ];
  };
}
