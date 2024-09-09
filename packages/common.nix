{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
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

  programs = {
    # Allow binaries outside nix store (i.e. Neovim LSP's managed by mason)
    nix-ld.enable = true;

    fish.enable = true;

    neovim.enable = true;
    neovim.defaultEditor = true;
  };
}
