{
  lib,
  pkgs,
  ...
}:

let
  pname = "obsidian";
  version = "1.9.12";
  meta = with lib; {
    description = "Powerful knowledge base that works on top of a local folder of plain text Markdown files";
    homepage = "https://obsidian.md";
    downloadPage = "https://github.com/obsidianmd/obsidian-releases/releases";
    mainProgram = "obsidian";
    license = licenses.obsidian;
    maintainers = with maintainers; [
      atila
      conradmearns
      zaninime
      qbit
      kashw2
      w-lfchen
    ];
  };

  filename = "obsidian-${version}.tar.gz";
  src = pkgs.fetchurl {
    url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/${filename}";
    hash = "sha256-qS4M9gvCs3B2kOlImH/ddm0zjsVa4Zrhu2VEBKYNuMo=";
  };

  icon = pkgs.fetchurl {
    url = "https://obsidian.md/images/obsidian-logo-gradient.svg";
    hash = "sha256-EZsBuWyZ9zYJh0LDKfRAMTtnY70q6iLK/ggXlplDEoA=";
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "obsidian";
    desktopName = "Obsidian";
    comment = "Knowledge base";
    icon = "obsidian";
    exec = "obsidian %u";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/obsidian" ];
  };

  obsidian = pkgs.stdenv.mkDerivation {
    inherit
      pname
      version
      src
      desktopItem
      icon
      ;
    meta = meta // {
      platforms = [
        "x86_64-linux"
      ];
    };
    nativeBuildInputs = with pkgs; [
      makeWrapper
      imagemagick
    ];
    installPhase =
      let
        commandLineArgs = "";
      in
      ''
        runHook preInstall
        mkdir -p $out/bin
        makeWrapper ${pkgs.electron}/bin/electron $out/bin/obsidian \
          --add-flags $out/share/obsidian/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true}}" \
          --add-flags ${lib.escapeShellArg commandLineArgs}
        install -m 444 -D resources/app.asar $out/share/obsidian/app.asar
        install -m 444 -D resources/obsidian.asar $out/share/obsidian/obsidian.asar
        install -m 444 -D "${desktopItem}/share/applications/"* \
          -t $out/share/applications/
        for size in 16 24 32 48 64 128 256 512; do
          mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
          magick -background none ${icon} -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/obsidian.png
        done
        runHook postInstall
      '';

    passthru.updateScript = pkgs.writeScript "updater" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts
      set -eu -o pipefail
      latestVersion="$(curl -sS https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/desktop-releases.json | jq -r '.latestVersion')"
      update-source-version obsidian "$latestVersion"
    '';
  };
in

{
  config.home.packages = lib.mkIf pkgs.stdenv.isx86_64 [
    obsidian
  ];
}
