{
  config,
  pkgs,
  lib,
  ...
}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
  tmux-config-path = "/home/user/dotfiles/.config/tmux/tmux.conf";
  nfs-mount-options = [
    "fsc" #  Enable the cache of (read-only) data pages to the local disk
    "noauto" # Disable filesystem auto-mount on boot
    "nofail" # Do not report errors for this device if it does not exist
    "rw" # Mount filesystem as read-write
    "x-gvfs-show" # Show mounted filesystems on file explorer
    "x-systemd.automount" # Enable on-demand mounting
    "x-systemd.mount-timeout=1"
    "x-systemd.idle-timeout=600" # Unmount idle partitions after 10min
  ];
in {
  imports = [
    (import "${home-manager}/nixos")
    ./machines/desktop/configuration.nix
    ./machines/desktop/hardware-configuration.nix
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
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gnumake
    gparted
    grc
    impression
    kitty
    lazygit
    libsecret
    libreoffice-qt6-fresh
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
    tmux
    unzip
    vscode-fhs
    wget
    xclip
    zip
  ];

  home-manager.users.user = {
    home.username = "user";
    home.homeDirectory = "/home/user";

    programs = {
      home-manager.enable = true;

      kitty = {
        enable = true;
        font.name = "JetBrainsMono Nerd Font Mono";
        font.size = 13;
        theme = "Everforest Dark Medium";
        shellIntegration.mode = "no-cursor";
        settings = {
          adjust_line_height = "110%";
          adjust_column_width = "110%";
          confirm_os_window_close = 0;
          cursor_blink_interval = -1;
          cursor_shape = "block";
          cursor_stop_blinking_after = 0;
        };
      };

      tmux = {
        enable = true;
        extraConfig =
          if builtins.pathExists tmux-config-path
          then builtins.readFile tmux-config-path
          else "";
      };

      fish = {
        enable = true;
        shellInit = ''
          set fish_greeting # Disable greeting

          # Check if TMUX is unset or empty and if the session is interactive
          if test -z "$TMUX" && status is-interactive
            # Check if any Tmux sessions exist
            set tmux_sessions (tmux list-sessions)
            if test -z "$tmux_sessions"
              # If no sessions exist, start a new Tmux session
              tmux new-session
            else
              # If sessions exist, attach to the first one
              tmux attach-session -t (echo $tmux_sessions[1] | cut -d: -f1)
            end
          end
        '';

        functions = {
          removeDockerContainer.body = ''
            set -l regex $argv[1]

            # Get all container names
            set -l containers (docker ps -a --format "{{.Names}}")

            # Filter containers based on the regex
            for container in $containers
              if echo $container | grep -qE $regex
                docker rm -v --force $container
                echo "removed"
                echo -e "\n"
              end
            end
          '';
          removeDockerVolume.body = ''
            set -l regex $argv[1]

            # Get all volume names
            set -l volumes (docker volume ls -q)

            # Filter volumes based on the regex
            for volume in $volumes
              if echo $volume | grep -qE $regex
                echo "Found Volume: $volume"
                docker volume rm $volume
                echo -e "\n"
              end
            end
          '';
          removeNixGeneration.body = ''
            set -l start $argv[1]
            set -l end $argv[2]

            if test (count $argv) -eq 1
              # Only one argument provided, delete that single generation
              sudo nix-env --delete-generations $start --profile /nix/var/nix/profiles/system
            else if test (count $argv) -eq 2
              # Two arguments provided, delete the range of generations
              for i in (seq (math $start) (math $end))
                sudo nix-env --delete-generations $i --profile /nix/var/nix/profiles/system
              end
            else
              echo "Usage: removeNixGeneration <start> [end]"
            end
          '';
          listNixGenerations.body = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        };
      };

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
