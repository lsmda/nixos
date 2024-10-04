{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bison
    btop
    cargo
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
    nfs-utils
    nixfmt-rfc-style
    nodejs
    nodePackages.prettier
    nodePackages.pnpm
    pciutils
    pkg-config
    python3
    ripgrep
    rustc
    stow
    sqlite
    unzip
    wget
    xclip
    zip
  ];
}
