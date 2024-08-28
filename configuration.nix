{pkgs, ...}: {
  imports = [
    ./machines/desktop/configuration.nix
    ./machines/desktop/hardware-configuration.nix

    ./modules/packages/common.nix
    ./modules/packages/desktop.nix
    ./modules/home-manager.nix
    ./modules/services.nix
    ./modules/wireguard.nix
  ];

  users.groups.docker = {};

  users.users.user = {
    isNormalUser = true;
    description = "user";
    home = "/home/user";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  # Allow binaries outside nix store (i.e. Neovim LSP's managed by mason)
  programs.nix-ld.enable = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = ["JetBrainsMono"];
    })
  ];

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
}
