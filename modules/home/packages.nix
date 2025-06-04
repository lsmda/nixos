{ pkgs, ... }:

let
  # packages that require a desktop environment (gnome, kde, etc.)
  desktop = with pkgs; [
    (brave.override {
      commandLineArgs = [
        "--enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization"
        "--enable-zero-copy"
        "--use-gl=desktop"
        "--ignore-gpu-blocklist"
        "--enable-oop-rasterization"
        "--enable-raw-draw"
        "--enable-gpu-compositing"
        "--enable-gpu-rasterization"
        "--enable-native-gpu-memory-buffers"
        "--use-vulkan"
        "--disable-features=UseChromeOSDirectVideoDecoder"
      ];
    })
    discord
    firefox
    eog # image viewer
    ffmpegthumbnailer
    git-credential-manager
    gnome-calculator
    gnome-text-editor
    gnome-tweaks
    gnomeExtensions.alttab-scroll-workaround
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gparted # disk utility
    impression # usb image burner
    librewolf
    love # lua-based 2d game engine language
    mgba # gameboy emulator
    nautilus # file explorer
    obsidian
    qbittorrent
    spotify
    vscode-fhs
    winbox
    wlsunset # night light
    wpsoffice
    zotero
  ];

  # packages that run on terminal interfaces (headless systems)
  headless = with pkgs; [
    age
    cargo
    cryfs
    dive # tool for exploring docker images
    fastfetch
    fzf
    gcc
    gnumake
    go
    glow # render markdown on the CLI
    gocryptfs
    jq
    keychain
    lshw
    lua
    neovim
    nodejs
    nodePackages.pnpm
    pciutils # lspci, etc.
    python3
    ripgrep
    rustc
    soft-serve # Self-hosted Git server
    sops
    sqlite
    sqlitebrowser
    unzip
    wget
    xclip
    zip
  ];
in

{
  home.packages = headless ++ (if pkgs.stdenv.isx86_64 then desktop else [ ]);
}
