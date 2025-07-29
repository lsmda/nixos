{ lib, ... }:

let
  stringToAttributeSet = str: {
    name = str;
    value = { };
  };

  createUsersGroups =
    groupList:
    lib.pipe groupList [
      (map stringToAttributeSet)
      builtins.listToAttrs
    ];

  usersGroups = [
    "networkmanager"
    "wheel" # root
  ];
in

{
  inherit createUsersGroups usersGroups;
}
