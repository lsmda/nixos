{ lib, ... }:

{
  options.machine.username = lib.mkOption {
    type = lib.types.str;
    description = "Name of user account";
  };

  options.machine.hostname = lib.mkOption {
    type = lib.types.str;
    description = "Name of host machine";
  };

  options.lan.network = lib.mkOption {
    type = lib.types.str;
    description = "Local network address";
  };

  options.lan.gateway = lib.mkOption {
    type = lib.types.str;
    description = "Local network gateway address";
  };

  options.lan.storage = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Local network server address";
  };
}
