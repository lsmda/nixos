{ ... }@args:

with args.lib;

mkMerge [
  {
    home-manager.users.${args.username} = {
      programs.home-manager.enable = true;

      home.username = args.username;
      home.homeDirectory = "/home/${args.username}";
      home.stateVersion = "24.05";
    };

    home-manager.backupFileExtension = "backup";
  }

  args.cfg
]
