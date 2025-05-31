{
  services.postgresql.enable = true;
  services.postgresql.ensureDatabases = [ "user" ];
  services.postgresql.ensureUsers = [
    {
      name = "user";
      ensureDBOwnership = true;
    }
  ];
}
