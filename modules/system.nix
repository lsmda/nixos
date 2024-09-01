{pkgs, ...}: {
  users = {
    defaultUserShell = pkgs.fish;
    extraGroups.vboxusers.members = ["user"];

    groups.docker = {};

    users.user = {
      isNormalUser = true;
      description = "user";
      home = "/home/user";
      extraGroups = ["networkmanager" "wheel" "docker"];
    };
  };

  networking = {
    hostName = "device";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [5432];
  };

  programs = {
    # Allow binaries outside nix store (i.e. Neovim LSP's managed by mason)
    nix-ld.enable = true;

    fish.enable = true;

    neovim.enable = true;
    neovim.defaultEditor = true;
  };

  virtualisation.virtualbox.host.enable = true;

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  time.timeZone = "Europe/Lisbon";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Store audio state on reboot
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = ["JetBrainsMono"];
    })
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_6_8;
  };

  # Remove pre-installed apps
  documentation.nixos.enable = false;
  environment.gnome.excludePackages = [pkgs.gnome-tour];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
}
