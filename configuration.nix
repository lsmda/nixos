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

  networking.hostName = "machine";
  networking.networkmanager.enable = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  environment.systemPackages = with pkgs; [
    wget
    mpv
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
    programs.git.package = pkgs.gitFull;
    programs.git.userName = "lsmda";
    programs.git.userEmail = "lsmda@apollo.pm";

    programs.git-credential-oauth.enable = true;

    programs.gnome-shell.enable = true;
    programs.home-manager.enable = true;
    programs.gh.gitCredentialHelper.hosts = [
      "https://github.com"
      "https://gitlab.com"
    ];

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

  system.stateVersion = "24.05";
}
