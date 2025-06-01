{
  environment.etc."fonts/local.conf".text = ''
    i<?xml version="1.0"?>
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

  home.file.".Xresources".text = ''
    Xft.antialias: 1
    Xft.hinting: 1
    Xft.rgba: rgb
    Xft.hintstyle: hintslight
    Xft.lcdfilter: lcddefault 
  '';
}
