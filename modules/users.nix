{pkgs, ...}: {
  users = {
    defaultUserShell = pkgs.fish;

    groups.docker = {};

    users."user" = {
      isNormalUser = true;
      description = "user";
      home = "/home/user";
      extraGroups = ["networkmanager" "wheel" "docker"];
    };
  };
}
