{pkgs, ...}: {
  users = {
    defaultUserShell = pkgs.fish;

    groups.docker = {};

    users."user" = {
      isNormalUser = true;
      description = "user";
      home = "/home/user";
      hashedPassword = "$y$j9T$2gy4AbwUx4sj0UgSt5vza.$2HEAct5Ip.X1x9f0uYDDCTNbabDbAl8aZ78yDdSS/h5";
      extraGroups = ["networkmanager" "wheel" "docker"];
    };
  };
}
