{
  attrs,
  config,
  lib,
}:

let
  inherit (lib) mkMerge;
in

mkMerge [
  {
    home-manager.users.${config.machine.username} = {
      programs.home-manager.enable = true;

      home.username = config.machine.username;
      home.homeDirectory = "/home/${config.machine.username}";
      home.stateVersion = "24.05";
    };

    home-manager.backupFileExtension = "backup";
  }

  attrs
]
