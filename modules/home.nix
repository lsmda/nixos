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
      cursorTheme = {
        name = "BreezeX-RosePineDawn-Linux";
        package = pkgs.rose-pine-cursor;
      };
    };

    dconf = let
      background = "file:///home/user/dotfiles/wallpapers/background.jpg";
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

        # Sound
        "org/gnome/desktop/sound" = {
          event-sounds = false;
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
          picture-options = "spanned";
        };
        "org/gnome/desktop/screensaver" = {
          picture-uri = background;
        };
        "org/gnome/nautilus/icon-view" = {
          default-zoom-level = "large";
        };
        "org/gnome/nautilus/preferences" = {
          recursive-search = "always";
          show-image-thumbnails = "always";
          show-directory-item-counts = "always";
        };

        # Just Perfection Extension
        "org/gnome/shell/extensions/just-perfection" = {
          # Profile
          theme = true;

          # Visibility
          panel = false;
          panel-in-overview = true;
          activities-button = false;
          clock-menu = true;
          keyboard-layout = false;
          accessibility-menu = false;
          quick-settings = true;
          screen-sharing-indicator = true;
          screen-recording-indicator = true;
          world-clock = false;
          weather = false;
          calendar = true;
          events = false;
          search = false;
          dash = false;
          dash-separator = false;
          dash-app-running-indicator = false;
          show-applications-button = false;
          osd = true;
          workspace-popup = true;
          workspace = false;
          workspaces-in-app-grid = false;
          window-preview-close-button = true;
          window-preview-caption = false;
          background-menu = true;
          ripple-box = false;
          window-menu-take-screenshot-button = true;

          # Icons
          panel-notification-icon = true;
          power-icon = true;
          window-picker-icon = false;

          # Behavior
          workspace-wrap-around = false;
          workspace-peek = false;
          window-demands-attention-focus = false;
          window-maximized-on-create = true;
          type-to-search = true;
          workspace-switcher-should-show = false;
          overlay-key = true;
          double-super-to-appgrid = false;
          switcher-popup-delay = true;
          startup-status = 1;

          # Customize
          controls-manager-spacing-size = 50;
          workspace-background-corner-size = 1;
          panel-size = 0;
          panel-icon-size = 0;
          panel-button-padding-size = 0;
          panel-indicator-padding-size = 0;
          top-panel-position = 0;
          clock-menu-position = 0;
          clock-menu-position-offset = 0;
          workspace-switcher-size = 0;
          enable-animations = true;
          animation = 5;
          dash-icon-size = 0;
          notification-banner-position = 5;
          osd-position = 6;
          alt-tab-window-preview-size = 0;
          alt-tab-small-icon-size = 0;
          alt-tab-icon-size = 0;
          looking-glass-width = 0;
          looking-glass-height = 0;
        };
      };
    };

    home.stateVersion = "24.05";
  };

  home-manager.backupFileExtension = "backup";
}
