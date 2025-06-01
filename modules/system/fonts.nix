{ pkgs, ... }:

{
  environment.sessionVariables.FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
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
