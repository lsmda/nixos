{ pkgs, ... }:

let
  gui =
    with pkgs;
    [
      pulseaudio
      ashpd-demo # XDG portals tester
      discord
      ffmpegthumbnailer
      love # lua-based 2d game engine language
      mgba # gameboy emulator
      pavucontrol
      qbittorrent
      spotify
      wlsunset # night light
      wpsoffice
      zotero
      xwayland-satellite
      wayland
      wayland-protocols
      wayland-utils
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
    ]

    # Nvidia
    ++ [
      egl-wayland
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];

  cli = with pkgs; [
    age
    caddy
    cargo
    dive # explore docker images
    fzf
    gcc
    gnumake
    go
    glow # render markdown on CLI
    jq # cli JSON processor
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
    yt-dlp
    zip
  ];
in

{
  imports = [
    ../../packages/cloudflared
    ../../packages/obsidian
    ../../packages/quickshell
  ];

  config = {
    home.packages = cli ++ (if pkgs.stdenv.isx86_64 then gui else [ ]);
  };
}
