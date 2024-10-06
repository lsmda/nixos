username: {
  users.users = {
    ${username} = {
      uid = 1000;
      isNormalUser = true;
      group = "users";
      home = "/home/${username}";
      hashedPassword = "$y$j9T$2gy4AbwUx4sj0UgSt5vza.$2HEAct5Ip.X1x9f0uYDDCTNbabDbAl8aZ78yDdSS/h5";

      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
    };
  };
}
