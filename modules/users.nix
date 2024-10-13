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
      hashedPasswordFile = config.sops.secrets."user/hashedPassword".path;

      extraGroups = [
        "docker"
        "networkmanager"
        "wheel"
      ];
    };
  };
}
