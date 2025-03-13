{ pkgs, ... }:

let
  # packages that require a desktop environment (gnome, kde, etc.)
  desktop = with pkgs; [
    acpi
    alsa-utils
    brightnessctl
    discord
    eog
    eyedropper
    ffmpegthumbnailer
    flameshot
    ghostty
    git-credential-manager
    gnome-calculator
    gnome-text-editor
    gnome-tweaks
    gnomeExtensions.alttab-scroll-workaround
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gnupg
    gparted
    impression
    imwheel
    librewolf
    love # lua-based 2d game engine language
    mgba
    nautilus
    obsidian
    pass
    picom
    pika-backup
    playerctl
    protonvpn-gui
    pulseaudio
    qbittorrent
    rancher
    redshift
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
    gnumake
    go
    gocryptfs
    grc
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
