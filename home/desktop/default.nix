{ pkgs, ... }:

let
  makeDesktopIcon =
    {
      name,
      desktopName,
      exec,
      categories,
      mimeTypes,
      iconUrl,
      iconHash,
    }@cfg:

    pkgs.stdenv.mkDerivation rec {
      name = cfg.name;

      desktopItem = pkgs.makeDesktopItem {
        name = cfg.name;
        desktopName = cfg.desktopName;
        icon = cfg.name;
        exec = cfg.exec;
        categories = cfg.categories;
        mimeTypes = cfg.mimeTypes;
      };

      icon = pkgs.fetchurl {
        url = cfg.iconUrl;
        hash = cfg.iconHash;
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
          magick -background none ${icon} -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/${cfg.name}.png
        done
        runHook postInstall
      '';
    };

  kimai = makeDesktopIcon {
    name = "kimai";
    desktopName = "Kimai";
    exec = "xdg-open https://kimai.lsmda.pm";
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeTypes = [ "x-scheme-handler/https" ];
    iconUrl = "https://raw.githubusercontent.com/kimai/kimai/refs/heads/main/public/favicon/mstile-310x310.png";
    iconHash = "sha256-bmRg7W1yzg4Y9fHH9POPdiyRQ74y/+7zbWH38a1fKh8=";
  };

  teams = makeDesktopIcon {
    name = "teams";
    desktopName = "Microsoft Teams";
    exec = "xdg-open https://teams.microsoft.com/v2";
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeTypes = [ "x-scheme-handler/https" ];
    iconUrl = "https://cdn.svglogos.dev/logos/microsoft-teams.svg";
    iconHash = "sha256-BalwC3cffNiTL4uu/VwhtB6oCiiDdN10ljU4Xv0UHDc=";
  };
in

{
  config.home.packages = [
    kimai
    teams
  ];
}
