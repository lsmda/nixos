{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
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
    extraGroups = [ "networkmanager" "wheel" "docker"];
  };

  networking.hostName = "device";
  networking.networkmanager.enable = true;

  programs.fish.enable = true;
  programs.firefox.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  environment.systemPackages = with pkgs; [
    bison
    btop
    docker
    fzf
    gnome.gnome-terminal
    gnome.gnome-tweaks
    gnome.nautilus
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    grc
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

    (chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
  ];

  home-manager.users.user = {
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
    programs.git-credential-oauth.enable = true;
    programs.git-credential-oauth.package = pkgs.git-credential-manager;

    programs.gnome-shell.enable = true;
    programs.home-manager.enable = true;

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

  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon 
  ];

  time.timeZone = "Europe/Lisbon";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  services.xserver.xkb.layout = "pt";
  services.xserver.xkb.variant = "";

  console.keyMap = "pt-latin1";
  services.printing.enable = true;

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # For Broadwell (2015) or newer processors. LIBVA_DRIVER_NAME=iHD
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = lib.mkDefault false;
    alsa.enable = false;
    alsa.support32Bit = false;
    pulse.enable = false;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
}
