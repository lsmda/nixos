{ pkgs, ... }:

let
  __vscode = (pkgs.vscode.override { commandLineArgs = [ "--use-gl=desktop" ]; }).fhs;

  # packages that require a desktop environment (gnome, kde, etc.)
  desktop = with pkgs; [
    (brave.override {
      commandLineArgs = [
        "--enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization"
        "--use-gl=desktop"
        "--enable-gpu-compositing"
        "--enable-gpu-rasterization"
        "--enable-native-gpu-memory-buffers"
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
    __vscode
    winbox
    wlsunset # night light
    wpsoffice
    zotero
  ];

  # packages that run on terminal interfaces (headless systems)
  headless = with pkgs; [
    age
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
    tree
    unzip
    wget
    xclip
    zip
  ];
in

{
  home.packages = headless ++ (if pkgs.stdenv.isx86_64 then desktop else [ ]);
}
