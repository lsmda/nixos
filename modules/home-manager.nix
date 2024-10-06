{
  cfg,
  lib,
  user,
  ...
}:

with lib;

mkMerge [
  {
    home-manager.users.${user} = {
      programs.home-manager.enable = true;

      home.username = user;
      home.homeDirectory = "/home/${user}";
      home.stateVersion = "24.05";
    };

    home-manager.backupFileExtension = "backup";
  }

  cfg
]
