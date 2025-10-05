{ config, lib, ... }:

let
  default = builtins.readFile ./configuration/default.kdl;
  hostname = builtins.readFile ./configuration/${config.machine.hostname}.kdl;
in

{
  home.file.".config/niri/config.kdl".text = lib.strings.concatStringsSep "" [
    default
    hostname
  ];
}
