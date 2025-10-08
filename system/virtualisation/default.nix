{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ../../utils { inherit config lib; }) createUsersGroups;
in

{
  config = {
    users.groups = createUsersGroups [ "podman" ];

    virtualisation = {
      containers.enable = true;
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    # Enable on x86_64 architecture
    virtualisation.virtualbox.host.enable = pkgs.stdenv.isx86_64;
    users.extraGroups.vboxusers.members = [ config.machine.username ];
  };
}
