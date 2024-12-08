username: cfg:

{
  home-manager.users.${username} = {
    programs.home-manager.enable = true;

    home.username = username;
    home.homeDirectory = "/home/${username}";
  } // cfg;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.backupFileExtension = "backup";
}
