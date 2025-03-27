{ pkgs, ... }:

let
  # packages that require a desktop environment (gnome, kde, etc.)
  desktop = with pkgs; [
    acpi
    discord
    eog
    eyedropper
    flameshot
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
    pika-backup
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
    nnn # file manager
    nodejs
    nodePackages.pnpm
    pciutils
    pkg-config
    python3
    ripgrep
    rustc
    sops
    sqlite
    sqlitebrowser
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
