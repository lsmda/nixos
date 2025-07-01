{ lib, pkgs, ... }:

let
  inherit (import ../utils { inherit lib; }) createUsersGroups;
  serviceUser = "postgresql";

  sql-file = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/pthom/northwind_psql/c1035fc5b5dfa45f164a7bc4a1632656f0025642/northwind.sql";
    sha256 = "1dk9x2hfikw2xpnl2v3j5r8k2cc32srldg2z7c2z20m17aamykpp";
  };

  northwind-sql = pkgs.stdenv.mkDerivation {
    pname = "northwind-sql";
    version = "0.0.1";
    builder = pkgs.writeText "builder.sh" ''
      . $stdenv/setup
      mkdir -pv $out/share/
      cp ${sql-file} $out/share/northwind.sql
    '';
    meta = with lib; {
      description = "The Microsoft Northwind database.";
      homepage = "https://github.com/pthom/northwind_psql";
      platforms = platforms.all;
    };
  };
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
    initialScript = pkgs.writeText "initScript" ''
      CREATE USER ice;
      CREATE DATABASE ice OWNER ice;
      GRANT ALL PRIVILEGES ON DATABASE ice TO "ice";
      \connect ice
      SET ROLE 'ice';
      \i /home/user/chinook.sql
    '';
  };
}
