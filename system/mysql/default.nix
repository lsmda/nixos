{ config, lib, ... }:

let
  secrets = config.sops.secrets;
  inherit (import ../../utils { inherit config lib; }) fromBinary;
in

{
  sops.secrets."mysql/store" = fromBinary ../../secrets/mysql/store // {
    restartUnits = [ "podman-mysql.service" ];
  };

  virtualisation.oci-containers.containers."mysql" = {
    autoStart = true;
    image = "mysql:latest";
    volumes = [
      "db:/var/lib/mysql"
    ];
    environmentFiles = [
      secrets."mysql/store".path
    ];
    ports = [ "8003:3306" ];
  };
}
