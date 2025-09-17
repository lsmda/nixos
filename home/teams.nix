{ pkgs, ... }:

let
  teams = pkgs.stdenv.mkDerivation rec {
    name = "teams";

    desktopItem = pkgs.makeDesktopItem {
      name = name;
      desktopName = "Microsoft Teams";
      icon = name;
      exec = "firefox --new-window https://teams.microsoft.com/v2";
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeTypes = [
        "x-scheme-handler/https"
      ];
    };

    icon = pkgs.fetchurl {
      url = "https://cdn.svglogos.dev/logos/microsoft-teams.svg";
      hash = "sha256-BalwC3cffNiTL4uu/VwhtB6oCiiDdN10ljU4Xv0UHDc=";
    };

    nativeBuildInputs = with pkgs; [
      makeWrapper
      imagemagick
    ];

    unpackPhase = ''
      echo "Skipping default unpack phase"
    '';

    installPhase = ''
      runHook preInstall
      install -m 444 -D "${desktopItem}/share/applications/"* \
        -t $out/share/applications/
      for size in 16 24 32 48 64 128 256 512; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick -background none ${icon} -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/${name}.png
      done
      runHook postInstall
    '';
  };
in

{
  home.packages = [
    teams
  ];
}
