{ lib, pkgs, ... }:

let
  obsidian = import ../packages/obsidian.nix { inherit lib pkgs; };

  # packages that require a desktop environment (gnome, kde, etc.)
  desktop = with pkgs; [
    discord
    eog # image viewer
    ffmpegthumbnailer
    gnome-calculator
    gnome-text-editor
    gnome-tweaks
    gnomeExtensions.alttab-scroll-workaround
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gparted # disk utility
    impression # usb image burner
    jetbrains.idea-community
    jetbrains.webstorm
    love # lua-based 2d game engine language
    mgba # gameboy emulator
    nautilus # file explorer
    obsidian
    pavucontrol
    qbittorrent
    spotify
    winbox
    wlsunset # night light
    wpsoffice
    zotero
  ];

  # packages that run on terminal interfaces (headless systems)
  headless = with pkgs; [
    age
    caddy
    cargo
    cloudflared
    cryfs
    dive # tool for exploring docker images
    fastfetch
    fzf
    gcc
    gnumake
    go
    glow # render markdown on the CLI
    gocryptfs
    jq # cli JSON processor
    keychain # keys management tool (GPG, SSH)
    lshw
    lua
    mariadb
    neovim
    nodejs
    nodePackages.pnpm
    nodePackages.yarn
    pciutils # lspci, etc.
    python3
    restic
    ripgrep
    rustc
    soft-serve # self-hosted Git server
    sops
    sqlite
    sqlitebrowser
    tree
    unzip
    wget
    xclip
    zip
  ];
in

{
  config = {
    home.packages = headless ++ (if pkgs.stdenv.isx86_64 then desktop else [ ]);
  };
}
