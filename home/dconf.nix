{ lib, ... }:

# use `dconf watch /` to track state changes, then set them here.

{
  dconf.settings = {
    # displays
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
      night-light-schedule-from = 0.0;
      night-light-schedule-to = 0.0;
      night-light-temperature = lib.hm.gvariant.mkUint32 3700;
    };

    # sound
    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };

    # power
    "org/gnome/control-center" = {
      last-panel = "power";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      sleep-inactive-ac-type = "nothing";
      power-button-action = "nothing";
      power-saver-profile-on-low-battery = false;
      sleep-inactive-battery-type = "nothing";
    };

    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 0;
    };

    # multitasking
    "org/gnome/desktop/interface" = {
      accent-color = "slate";
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

    "org/gnome/mutter" = {
      edge-tiling = true;
      workspaces-only-on-primary = false;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    # appearence
    "org/gnome/desktop/background" = {
      picture-options = "spanned";
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "large";
    };

    "org/gnome/nautilus/preferences" = {
      recursive-search = "always";
      show-image-thumbnails = "always";
      show-directory-item-counts = "always";
    };

    "org/gnome/shell" = {
      last-selected-power-profile = "performance";
      # active extensions
      enabled-extensions = [
        "alt-tab-scroll-workaround@lucasresck.github.io"
        "appindicatorsupport@rgcjonas.gmail.com"
        "just-perfection-desktop@just-perfection"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    # gnome tweaks extension
    "org/gnome/desktop/interface" = {
      font-antialiasing = "rgba";
      font-hinting = "full";
      text-scaling-factor = 1;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/mutter" = {
      center-new-windows = true;
    };

    "org/gnome/desktop/interface" = {
      monospace-font-name = "JetBrainsMono Nerd Font Mono 12";
    };

    # just perfection extension
    "org/gnome/shell/extensions/just-perfection" = {
      # profile
      theme = true;

      # visibility
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

      # icons
      panel-notification-icon = true;
      power-icon = true;
      window-picker-icon = false;

      # behavior
      workspace-wrap-around = false;
      workspace-peek = true;
      window-demands-attention-focus = false;
      window-maximized-on-create = true;
      type-to-search = true;
      workspace-switcher-should-show = false;
      overlay-key = true;
      double-super-to-appgrid = false;
      switcher-popup-delay = true;
      startup-status = 1;

      # customize
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
}