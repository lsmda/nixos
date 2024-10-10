{ lib, ... }:

{
  options = {
    machine.username = lib.mkOption { type = lib.types.str; };
    machine.hostname = lib.mkOption { type = lib.types.str; };
  };
}
