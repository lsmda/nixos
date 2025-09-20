{ config, lib, ... }:

let
  sops = import ./sops.nix { inherit config lib; };
  users = import ./users.nix { inherit lib; };
in

{
  inherit (sops)
    fromBinary
    fromDotenv
    fromFile
    fromYaml
    withOwner
    ;
  inherit (users) createUsersGroups usersGroups;
}
