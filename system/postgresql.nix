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
    ensureUsers = [
      {
        name = config.machine.username;
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
