{
  config = {
    programs.nix-ld.enable = true;

    # Enables simultaneous use of processor threads.
    security = {
      allowSimultaneousMultithreading = true; # Allow simultaneous multithreading (SMT).
      rtkit.enable = true; # Enable RealtimeKit (rtkit) for managing real-time priorities.
    };
  };
}
