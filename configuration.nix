{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
  one_minute = 60;
  one_hour = one_minute * 60;
  one_day = one_hour * 24;
  one_month = one_day * 30;
  keyboard = {
    us = {
      keyMap = "en-us";
      layout = "us";
    };
    pt = {
      keyMap = "pt-latin1";
      layout = "pt";
    };
  };
in
{
  imports = [
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
  ];

  users.groups.docker = {};

  users.users.user = {
    isNormalUser = true;
    description = "user";
    home = "/home/user";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  networking.hostName = "device";
  networking.networkmanager.enable = true;

  programs.fish.enable = true;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  environment.systemPackages = with pkgs; [
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
    fzf
    gnome.gnome-terminal
    gnome.gnome-tweaks
    gnome.nautilus
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    grc
    libsecret
    mpv
    neofetch
    nodejs
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

    programs.fish.enable = true;
    programs.fish.interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';

    programs.fish.functions = {
      deleteGenerationsRange = ''
        function deleteGenerationsRange --description 'Delete a range of NixOS generations'
          for i in (seq $argv[1] $argv[2])
            sudo nix-env --delete-generations $i --profile /nix/var/nix/profiles/system
          end
        end
      '';
      listGenerations = ''
        function listGenerations --description 'List NixOS generations'
          sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
        end
      '';
    };

    programs.neovim.enable = true;
    programs.neovim.extraLuaConfig = ''
      ${builtins.readFile ./nvim/lua/lsmda/core/options.lua} 
      ${builtins.readFile ./nvim/lua/lsmda/core/keymaps.lua} 
    '';

    programs.git.enable = true;
    programs.git.userName = "lsmda";
    programs.git.userEmail = "lsmda@apollo.pm";
    programs.git.extraConfig = {
      core = {
        commentChar = ";";
      };
      credential = {
        helper = lib.mkDefault "cache --timeout ${toString ONE_MONTH}";
      };
    };

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
      fonts = [ "JetBrainsMono" ];
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
  services.xserver.xkb.layout = keyboard.pt.layout;
  services.xserver.xkb.variant = "";
  console.keyMap = keyboard.pt.keyMap;

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
          src = pkgs.fetchFromGitLab  {
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
