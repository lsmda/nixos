{
  config = {
    environment.variables = {
      CLUTTER_BACKEND = "wayland"; # Specifies Wayland as the backend for Clutter.
      LIBVA_DRIVER_NAME = "intel"; # Force Intel i965 driver
      MOZ_ENABLE_WAYLAND = "1"; # Enables Wayland support in Mozilla applications (e.g., Firefox).
      NIXOS_OZONE_WL = "1"; # Enables the Ozone Wayland backend for Chromium-based browsers.
      NIXPKGS_ALLOW_UNFREE = "1"; # Allows the installation of packages with unfree licenses in Nixpkgs.
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # Disables window decorations in Qt applications when using Wayland.
      SDL_VIDEODRIVER = "wayland"; # Sets the video driver for SDL applications to Wayland.
      TOLGAOS_VERSION = "2.2";
      TOLGAOS = "true";
    };

    # Enables simultaneous use of processor threads.
    security = {
      allowSimultaneousMultithreading = true; # Allow simultaneous multithreading (SMT).
      rtkit.enable = true; # Enable RealtimeKit (rtkit) for managing real-time priorities.
    };
  };
}
