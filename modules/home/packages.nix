{ pkgs, ... }:

let
  # packages that require a desktop environment (gnome, kde, etc.)
  desktop = with pkgs; [
    (chromium.override {
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
    discord
    eog
    eyedropper
    ffmpegthumbnailer
    flameshot
    git-credential-manager
    gnome-calculator
    gnome-text-editor
    gnome-tweaks
    gnomeExtensions.alttab-scroll-workaround
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gparted
    impression
    imwheel
    kitty
    love # lua-based 2d game engine language
    mgba
    nautilus
    obsidian
    pika-backup
    protonvpn-gui
    qbittorrent
    spotify
    vscode-fhs
    winbox
    wpsoffice
  ];

  # packages that run on terminal interfaces (headless systems)
  headless = with pkgs; [
    age
    bison
    btop
    cargo
    dive # tool for exploring docker images
    docker
    fastfetch
    fzf
    gcc
    git
    gnumake
    go
    gocryptfs
    grc
    kitty
    lazygit
    lshw
    lua
    nfs-utils
    nixfmt-rfc-style
    nodejs
    nodePackages.prettier
    nodePackages.pnpm
    nushell
    pciutils
    pkg-config
    python3
    ripgrep
    rustc
    sops
    stow
    sqlite
    sqlitebrowser
    tmux
    unzip
    usbutils
    wget
    xclip
    zip
  ];
in

{
  home.packages = headless ++ (if pkgs.stdenv.isx86_64 then desktop else [ ]);
}