{
  config = {
    environment.variables = {
      LIBVA_DRIVER_NAME = "intel"; # Force Intel i965 driver
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
