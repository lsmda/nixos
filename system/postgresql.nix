{ config, lib, ... }:

let
  inherit (import ../utils { inherit lib; }) createUsersGroups;
  serviceUser = "postgresql";
in

{
  users.groups = createUsersGroups [ serviceUser ];

  users.users.${serviceUser} = {
    description = "PostgreSQL Service User";
    isSystemUser = true;
    group = serviceUser;
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ config.machine.username ];
    ensureUsers = [
      {
        name = config.machine.username;
        ensureDBOwnership = true;
        ensureClauses = {
          superuser = true;
          replication = true;
          createrole = true;
          createdb = true;
          bypassrls = true;
        };
      }
    ];
  };
}
