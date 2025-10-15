{ config, pkgs, ... }:

let
  inherit (import ../../utils { inherit config pkgs; }) createUsersGroups;
  serviceUser = "postgresql";
in

{
  config = {
    networking.firewall.allowedTCPPorts = [ 5432 ];

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
  };
}
