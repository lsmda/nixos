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

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  environment.systemPackages = with pkgs; [
    wget
    nodejs
    xclip
    bison
    ripgrep
    zip
    unzip
    tmux
    pkg-config
    btop
    fzf
    grc
    neofetch
    vscode

    docker
    spotify
    qbittorrent
    home-manager
    protonvpn-gui
    gnome.nautilus
    tela-icon-theme
    gnome.gnome-tweaks
    gnome.gnome-terminal
    git-credential-oauth
    gnomeExtensions.just-perfection
    gnomeExtensions.appindicator

   (chromium.override {
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
    programs.neovim.enable = true;
    programs.neovim.extraLuaConfig = ''
    ${builtins.readFile ./nvim/lua/lsmda/core/options.lua} 
    ${builtins.readFile ./nvim/lua/lsmda/core/keymaps.lua} 
    '';

    programs.gnome-shell.enable = true;
    programs.home-manager.enable = true;

    programs.git.enable = true;
    programs.git.userName = "lsmda";
    programs.git.userEmail = "lsmda@apollo.pm";
    programs.git.extraConfig.credential.helper = "oauth";

    gtk.enable = true;
    gtk.iconTheme.name = "Tela-grey-dark";

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
  services.gnome.gnome-keyring.enable = true;

  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon 
  ];

  networking.hostName = "machine";
  networking.networkmanager.enable = true;

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

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  security.rtkit.enable = true;

  nixpkgs.config.allowUnfree = true;

  # GNOME 46: triple-buffering-v4-46
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

  system.stateVersion = "24.05";
}
