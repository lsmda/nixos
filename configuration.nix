{
  config,
  pkgs,
  lib,
  ...
}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
  nfs-mount-options = [
    "fsc" #  Enable the cache of (read-only) data pages to the local disk
    "noauto" # Disable filesystem auto-mount on boot
    "rw" # Mount filesystem as read-write
    "x-gvfs-show" # Show mounted filesystems on file explorer
    "x-systemd.after=graphical.target"
    "x-systemd.requires=graphical.target"
    "x-systemd.automount" # enable on-demand mounting
    "x-systemd.mount-timeout=1"
    "x-systemd.idle-timeout=600" # Unmount idle partitions after 10min
  ];
in {
  imports = [
    (import "${home-manager}/nixos")
    ./machines/laptop/configuration.nix
    ./machines/laptop/hardware-configuration.nix
  ];

  # Network devices
  fileSystems."/mnt/nfs/files" = {
    device = "10.0.0.5:/files";
    fsType = "nfs";
    options = nfs-mount-options;
  };

  fileSystems."/mnt/nfs/media" = {
    device = "10.0.0.5:/media";
    fsType = "nfs";
    options = nfs-mount-options;
  };

  users.groups.docker = {};

  users.users.user = {
    isNormalUser = true;
    description = "user";
    home = "/home/user";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  networking.hostName = "device";
  networking.networkmanager.enable = true;

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
    ffmpegthumbnailer
    firefox
    fzf
    gcc
    git-credential-oauth
    gnome.eog
    gnome.gnome-tweaks
    gnome.nautilus
    gnomeExtensions.alttab-scroll-workaround
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gnumake
    gparted
    grc
    impression
    kitty
    lazygit
    libsecret
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
    patchelf
    pciutils
    pika-backup
    pkg-config
    protonvpn-gui
    python3
    python312Packages.pip
    qbittorrent
    ripgrep
    spotify
    stow
    tmux
    unzip
    vscode-fhs
    wget
    wpsoffice
    xclip
    zed-editor
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
        userEmail = "lsmda@apollo.pm";
        extraConfig = {
          credential.credentialStore = "secretservice";
          credential.helper = [
            "store"
            "cache --timeout 86400" # 24 Hours
            "oauth"
          ];
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;

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

  security.rtkit.enable = true;

  # Store audio state on reboot
  sound.enable = true;

  hardware.pulseaudio.enable = false;

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
