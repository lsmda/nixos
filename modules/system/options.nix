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
}
