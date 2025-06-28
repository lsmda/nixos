{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # enable on x86_64 architectures
  virtualisation.virtualbox.host.enable = pkgs.stdenv.isx86_64;
  users.extraGroups.vboxusers.members = [ config.machine.username ];
}
