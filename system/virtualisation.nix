{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ../utils { inherit lib; }) createUsersGroups;
  serviceUser = "docker";
in

{
  users.groups = createUsersGroups [ serviceUser ];

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

  # Enable on x86_64 architecture
  virtualisation.virtualbox.host.enable = pkgs.stdenv.isx86_64;
  users.extraGroups.vboxusers.members = [ config.machine.username ];
}
