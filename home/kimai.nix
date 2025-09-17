{ pkgs, ... }:

let
  kimai = pkgs.stdenv.mkDerivation rec {
    name = "kimai";

    desktopItem = pkgs.makeDesktopItem {
      name = name;
      desktopName = "Kimai";
      icon = name;
      exec = "firefox --new-window https://kimai.lsmda.pm";
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeTypes = [
        "x-scheme-handler/https"
      ];
    };

    icon = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/kimai/kimai/refs/heads/main/public/favicon/mstile-310x310.png";
      hash = "sha256-bmRg7W1yzg4Y9fHH9POPdiyRQ74y/+7zbWH38a1fKh8=";
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
    kimai
  ];
}
