{ config, lib, ... }:

let
  keys = import ./keys.nix;
  sops = (import ./sops.nix { inherit config lib; });
  users = (import ./users.nix { inherit lib; });
in

{
  inherit keys;
  inherit (sops) fromBinary fromYaml withOwner;
  inherit (users) createUsersGroups usersGroups;
}
