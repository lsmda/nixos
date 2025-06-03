{ pkgs, ... }:

let
  charter = pkgs.callPackage ../pkgs/charter.nix { };
  consolas = pkgs.callPackage ../pkgs/consolas.nix { };
in

{
  environment.sessionVariables.FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";

  fonts.packages = with pkgs; [
    charter
    consolas
    inter
    nerd-fonts.jetbrains-mono
    open-sans
  ];

  fonts.fontconfig = {
    localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <match target="font">
          <edit name="antialias" mode="assign">
            <bool>true</bool>
          </edit>
          <edit name="hinting" mode="assign">
            <bool>true</bool>
          </edit>
          <edit mode="assign" name="rgba">
            <const>rgb</const>
          </edit>
          <edit mode="assign" name="hintstyle">
            <const>hintslight</const>
          </edit>
          <edit mode="assign" name="lcdfilter">
            <const>lcddefault</const>
          </edit>
        </match>
      </fontconfig>
    '';
  };
}
