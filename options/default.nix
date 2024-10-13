{ lib, ... }:

{
  options = {
    machine.username = lib.mkOption {
      type = lib.types.str;
      description = "Name of user account";
    };

    machine.hostname = lib.mkOption {
      type = lib.types.str;
      description = "Name of host machine";
    };

    lan.network = lib.mkOption {
      type = lib.types.str;
      description = "Local area network address";
    };

    lan.gateway = lib.mkOption {
      type = lib.types.str;
      description = "Local area network gateway address";
    };

    lan.server = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Local area network nfs server address";
    };
  };
}
