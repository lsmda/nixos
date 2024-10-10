{ config, pkgs }:

{
  users.groups.docker = { }; # create docker group

  users.users = {
    ${config.machine.username} = {
      uid = 1000;
      isNormalUser = true;
      group = "users";
      home = "/home/${config.machine.username}";
      shell = pkgs.fish;
      hashedPassword = config.sops.secrets.hashed_password.path;

      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
    };
  };
}
