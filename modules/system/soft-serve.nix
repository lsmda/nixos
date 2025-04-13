{
  environment.variables = {
    SOFT_SERVE_DATA_PATH = "/srv/soft-serve";
  };

  services.soft-serve = {
    enable = true;
    settings = {
      name = "Runestore";
      log_format = "text";
      ssh = {
        listen_addr = ":23231";
        public_url = "ssh://localhost:23231";
        max_timeout = 30;
        idle_timeout = 120;
      };
      stats.listen_addr = ":23233";
    };
  };
}
