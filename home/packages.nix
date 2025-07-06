{ pkgs, ... }:

let
  __vscode = (pkgs.vscode.override { commandLineArgs = [ "--use-gl=desktop" ]; }).fhs;

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
    love # lua-based 2d game engine language
    mgba # gameboy emulator
    nautilus # file explorer
    obsidian
    pavucontrol
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
    jq # CLI JSON processor
    keychain # keys management tool (GPG, SSH)
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
    zed-editor-fhs
    zip
  ];
in

{
  home.packages = headless ++ (if pkgs.stdenv.isx86_64 then desktop else [ ]);
}
