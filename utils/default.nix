{ config, pkgs, ... }:

let
  sops = import ./sops.nix { inherit config pkgs; };
  users = import ./users.nix { inherit config pkgs; };
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
