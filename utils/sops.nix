{ config, lib, ... }:

let
  sopsFile = path: {
    mode = "0400";
    sopsFile = path;
    owner = config.machine.username;
  };

  fromYaml = path: sopsFile path // { format = "yaml"; };
  fromBinary = path: sopsFile path // { format = "binary"; };
  fromDotenv = path: sopsFile path // { format = "dotenv"; };

  withOwner =
    user: set:
    let
      userExists = lib.hasAttr user config.users.users;
      owner = if userExists then user else "root";
    in
    set // { owner = owner; };
in

{
  inherit
    fromBinary
    fromDotenv
    fromYaml
    withOwner
    ;
}
