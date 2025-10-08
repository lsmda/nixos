{
  config = {
    environment.variables = {
      MOZ_ENABLE_WAYLAND = 1;
      ELECTRON_OZONE_PLATFORM_HINT = "auto";

      # Qt theming
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";

      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "niri";

      # Electron & Chromium
      NIXOS_OZONE_WL = "1";

      # NVIDIA-specific
      GBM_BACKEND = "nvidia-drm";
      WLR_NO_HARDWARE_CURSORS = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct"; # For hardware video acceleration
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    programs.nix-ld.enable = true;

    # Enables simultaneous use of processor threads.
    security = {
      allowSimultaneousMultithreading = true; # Allow simultaneous multithreading (SMT).
      rtkit.enable = true; # Enable RealtimeKit (rtkit) for managing real-time priorities.
    };
  };
}
