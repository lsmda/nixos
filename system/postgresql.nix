{ config, lib, ... }:

let
  inherit (import ../utils { inherit config lib; }) createUsersGroups;
  serviceUser = "postgresql";
in

{
  users.groups = createUsersGroups [ serviceUser ];

  users.users.${serviceUser} = {
    description = "Service user for PostgreSQL";
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
