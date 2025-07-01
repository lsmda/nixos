{ lib, ... }:

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
    ensureDatabases = [ serviceUser ];
    ensureUsers = [
      {
        name = serviceUser;
        ensureDBOwnership = true;
        ensureClauses.superuser = true;
        ensureClauses.createrole = true;
        ensureClauses.createdb = true;
      }
    ];
  };
}
