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
    ./machines/desktop/configuration.nix
    ./machines/desktop/hardware-configuration.nix
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

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemuPackage = pkgs.qemu_kvm;

  # Allow binaries outside nix store (i.e. Neovim LSP's managed by mason)
  programs.nix-ld.enable = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # Remove pre-installed apps
  documentation.nixos.enable = false;
  environment.gnome.excludePackages = [pkgs.gnome-tour];
  services.xserver.excludePackages = [pkgs.xterm];
  services.xserver.desktopManager.xterm.enable = false;

  environment.systemPackages = with pkgs; [
    alejandra
    alsa-utils
    bison
    btop
    (chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
    docker
    eyedropper
    ffmpegthumbnailer
    firefox
    fzf
    gcc
    git-credential-manager
    gnome.eog
    gnome.gnome-tweaks
    gnome.nautilus
    gnomeExtensions.alttab-scroll-workaround
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gnumake
    gocryptfs
    gparted
    grc
    impression
    imwheel
    kitty
    lazygit
    lshw
    (
      mpv.override {
        scripts = [
          mpvScripts.evafast
          mpvScripts.memo
          mpvScripts.mpris
          mpvScripts.thumbfast
          mpvScripts.modernx
        ];
      }
    )
    neofetch
    nfs-utils
    nodejs
    nodePackages.prettier
    nodePackages.pnpm
    obsidian
    ollama
    pciutils
    pika-backup
    pkg-config
    protonvpn-gui
    python3
    python312Packages.pip
    python312Packages.torch
    python312Packages.torchvision
    python312Packages.torchaudio
    qbittorrent
    rar
    ripgrep
    spotify
    stow
    sqlite
    textpieces
    tmux
    unrar
    unzip
    virt-manager
    virt-viewer
    vscode-fhs
    wget
    wpsoffice
    xclip
    zip
  ];

  home-manager.users.user = {
    home.username = "user";
    home.homeDirectory = "/home/user";

    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        userName = "lsmda";
        userEmail = "contact@lsmda.pm";
        extraConfig = {
          credential.credentialStore = "secretservice";
          credential.helper = ["manager"];
        };
      };
    };

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

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.core-utilities.enable = false;
  services.printing.enable = true;

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

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Store audio state on reboot
  sound.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
}
