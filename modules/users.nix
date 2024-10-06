{ pkgs, user }:

{
  users.groups.docker = { }; # create docker group

  users.users = {
    ${user} = {
      uid = 1000;
      isNormalUser = true;
      group = "users";
      home = "/home/${user}";
      shell = pkgs.fish;
      hashedPassword = "$y$j9T$2gy4AbwUx4sj0UgSt5vza.$2HEAct5Ip.X1x9f0uYDDCTNbabDbAl8aZ78yDdSS/h5";

      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
    };
  };
}
