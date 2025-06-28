{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "user" ];
    ensureUsers = [
      {
        name = "user";
        ensureDBOwnership = true;
      }
    ];
  };
}
