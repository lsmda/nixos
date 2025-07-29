{ lib, ... }:

let
  keys = import ./keys.nix;
  users = (import ./users.nix { inherit lib; });
in

{
  inherit keys;
  inherit (users) createUsersGroups usersGroups;
}
