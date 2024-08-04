{
  config,
  pkgs,
  lib,
  ...
}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
    ./machines/desktop.nix
    ./hardware-configuration.nix
  ];

  users.groups.docker = {};

  users.users.user = {
    isNormalUser = true;
    description = "user";
    home = "/home/user";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  networking.hostName = "device";
  networking.networkmanager.enable = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  programs.nix-ld.enable = true;

  environment.gnome.excludePackages = [pkgs.gnome-tour];

  environment.systemPackages = with pkgs; [
    alejandra
    alsa-utils
    bison
    btop
    cartridges
    (chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
    docker
    fzf
    gcc
    gnome.gnome-terminal
    gnome.gnome-tweaks
    gnome.nautilus
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gnumake
    grc
    impression
    kitty
    lazygit
    libsecret
    lshw
    mpv
    neofetch
    nodejs
    notes
    patchelf
    pciutils
    pika-backup
    pkg-config
    protonvpn-gui
    qbittorrent
    ripgrep
    spotify
    tmux
    unzip
    vscode
    wget
    xclip
    zip
  ];

  home-manager.users.user = {
    programs.home-manager.enable = true;

    home.username = "user";
    home.homeDirectory = "/home/user";

    programs.kitty.enable = true;
    programs.kitty.font.name = "JetBrainsMono Nerd Font Mono";
    programs.kitty.font.size = 13;
    programs.kitty.theme = "Everforest Dark Medium";
    programs.kitty.shellIntegration.enableFishIntegration = true;

    programs.fish.enable = true;
    programs.fish.interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    programs.fish.functions = {
      deleteGenerationsRange.body = ''
        for i in (seq (math $argv[1]) (math $argv[2]))
          sudo nix-env --delete-generations $i --profile /nix/var/nix/profiles/system
        end
      '';
      listGenerations.body = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    };

    programs.git.enable = true;
    programs.git.userName = "lsmda";
    programs.git.userEmail = "lsmda@apollo.pm";
    programs.git-credential-oauth.enable = true;

    gtk.enable = true;
    gtk.iconTheme.name = "Tela-grey-dark";
    gtk.iconTheme.package = pkgs.tela-icon-theme;

    dconf.enable = true;
    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

    home.stateVersion = "24.05";
  };

  home-manager.backupFileExtension = "backup";

  fonts.packages = with pkgs; [
    (pkgs.nerdfonts.override {
      fonts = ["JetBrainsMono"];
    })
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.core-utilities.enable = false;

  # Required to run systray icons
  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];

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

  services.printing.enable = true;
  services.xserver.xkb.variant = "";

  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;

  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # GNOME 46: Triple Buffering
  nixpkgs.overlays = [
    (final: prev: {
      gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs (old: {
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.gnome.org";
            owner = "vanvugt";
            repo = "mutter";
            rev = "triple-buffering-v4-46";
            hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
          };
        });
      });
    })
  ];

  nixpkgs.config.allowAliases = false;
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
}
