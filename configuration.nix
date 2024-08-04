{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
  ];

  users.users.user = {
    isNormalUser = true;
    description = "user";
    home = "/home/user";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      # List user-specific packages here
    ];
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  environment.gnome.excludePackages = [ pkgs.gnome-tour pkgs.xterm ];

  environment.systemPackages = with pkgs; [
    wget
    nodejs
    git
    xclip
    bison
    pkg-config
    ripgrep
    zip
    unzip
    tmux
    neofetch
    btop
    vscode
    fzf
    grc

    pkgs.gnome.gnome-terminal
    pkgs.docker
    pkgs.spotify
    pkgs.qbittorrent
    pkgs.protonvpn-gui
    pkgs.gnome.nautilus
    pkgs.gnome.gnome-tweaks
    pkgs.gnomeExtensions.just-perfection

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
    
    programs.neovim.enable = true;
    programs.neovim.extraLuaConfig = ''
    ${builtins.readFile ./nvim/lua/lsmda/core/options.lua} 
    ${builtins.readFile ./nvim/lua/lsmda/core/keymaps.lua} 
    '';

    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
    };

    home.stateVersion = "24.05";
  };

  home-manager.backupFileExtension = "backup";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.core-utilities.enable = false;

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

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # support audio out
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;

  security.rtkit.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
}
