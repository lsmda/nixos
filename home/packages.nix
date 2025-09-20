{ pkgs, ... }:

let
  gui =
    with pkgs;
    [
      discord
      ffmpegthumbnailer
      love # lua-based 2d game engine language
      mgba # gameboy emulator
      obsidian
      pavucontrol
      qbittorrent
      spotify
      wlsunset # night light
      wpsoffice
      zotero
    ]

    # gnome tools
    ++ [
      eog # image viewer
      gnome-calculator
      gnome-text-editor
      gnome-tweaks
      gnomeExtensions.alttab-scroll-workaround
      gnomeExtensions.appindicator
      gnomeExtensions.just-perfection
      gparted # disk utility
      impression # usb image burner
      nautilus # file explorer

    ]

    # java development
    ++ [
      jetbrains.idea-community
      jetbrains.webstorm
      maven
      openjdk17
    ];

  cli = with pkgs; [
    age
    caddy
    cargo
    cloudflared
    cryfs
    dive # explore docker images
    fastfetch
    fzf
    gcc
    gnumake
    go
    glow # render markdown on CLI
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
    soft-serve # self-hosted git server
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
  imports = [
    ../packages/obsidian.nix
  ];

  config = {
    home.packages = cli ++ (if pkgs.stdenv.isx86_64 then gui else [ ]);
  };
}
