{ config, lib, ... }:

let
  sopsFile = path: {
    mode = "0400";
    sopsFile = path;
    owner = config.machine.username;
  };

  fromYaml = path: sopsFile path // { format = "yaml"; };
  fromBinary = path: sopsFile path // { format = "binary"; };

  withOwner =
    user: set:
    let
      userExists = lib.hasAttr user config.users.users;
      owner = if userExists then user else "root";
    in
    set // { owner = owner; };
in

{
  inherit fromBinary fromYaml withOwner;
}
