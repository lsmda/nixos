{pkgs, ...}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.user = {lib, ...}: {
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

    gtk = {
      enable = true;
      iconTheme = {
        name = "Tela-grey-dark";
        package = pkgs.tela-icon-theme;
      };
    };

    dconf = let
      background = "file:///home/user/dotfiles/wallpapers/background_00.jpg";
    in {
      enable = true;
      settings = {
        # Displays
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-schedule-automatic = false;
          night-light-schedule-from = 0.0;
          night-light-schedule-to = 0.0;
          night-light-temperature = lib.hm.gvariant.mkUint32 4200;
        };
        # Power
        "org/gnome/control-center" = {
          last-panel = "power";
        };
        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = "nothing";
          power-button-action = "nothing";
        };
        "org/gnome/desktop/session" = {
          idle-delay = lib.hm.gvariant.mkUint32 0;
        };
        # Multitasking
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
        };
        "org/gnome/mutter" = {
          edge-tiling = true;
          workspaces-only-on-primary = false;
        };
        "org/gnome/shell/app-switcher" = {
          current-workspace-only = true;
        };
        # Appearence
        "org/gnome/desktop/background" = {
          picture-uri = background;
          picture-uri-dark = background;
        };
        "org/gnome/desktop/screensaver" = {
          picture-uri = background;
        };
        "org/gnome/nautilus/icon-view" = {
          default-zoom-level = "large";
        };
      };
    };

    home.stateVersion = "24.05";
  };

  home-manager.backupFileExtension = "backup";
}
