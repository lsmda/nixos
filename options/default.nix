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

    lan.address = lib.mkOption {
      type = lib.types.str;
      description = "LAN ipv4 address";
    };

    lan.gateway = lib.mkOption {
      type = lib.types.str;
      description = "LAN gateway ipv4 address";
    };

    lan.server = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "LAN server ipv4 address";
    };
  };
}
