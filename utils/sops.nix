{ config, pkgs, ... }:

let
  inherit (pkgs) lib;

  sopsFile = path: {
    mode = "0400";
    sopsFile = path;
    owner = config.machine.username;
  };

  fromBinary = path: sopsFile path // { format = "binary"; };
  fromDotenv = path: sopsFile path // { format = "dotenv"; };
  fromFile = set: set // { key = ""; };
  fromYaml = path: sopsFile path // { format = "yaml"; };

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
    fromFile
    fromYaml
    withOwner
    ;
}
