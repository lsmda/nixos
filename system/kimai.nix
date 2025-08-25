{ config, lib, ... }:

let
  inherit (import ../utils { inherit config lib; }) fromBinary;
  secrets = config.sops.secrets;
in

{
  sops.secrets."kimai" = fromBinary ../secrets/kimai/kimai;
  sops.secrets."kimai-db" = fromBinary ../secrets/kimai/kimai-db;
  sops.secrets."kimai-local" = fromBinary ../secrets/kimai/kimai-local;

  virtualisation.oci-containers.containers."kimai" = {
    image = "kimai/kimai2:apache";
    autoStart = true;
    dependsOn = [ "kimai-db" ];
    environmentFiles = [
      secrets."kimai".path
    ];
    ports = [
      "8001:8001"
    ];
    volumes = [
      # kimai configuration file
      "${secrets."kimai-local".path}:/opt/kimai/config/packages/local.yaml:ro"

      "/var/lib/kimai/cache:/opt/kimai/var/cache"
      "/var/lib/kimai/data:/opt/kimai/var/data"
      "/var/lib/kimai/plugins:/opt/kimai/var/plugins"
    ];
  };

  virtualisation.oci-containers.containers."kimai-db" = {
    image = "mysql:9.4";
    autoStart = true;
    cmd = [
      "--default-storage-engine"
      "innodb"
    ];
    environmentFiles = [
      secrets."kimai-db".path
    ];
    volumes = [
      "/var/lib/kimai-db:/var/lib/mysql"
    ];
  };

  systemd.tmpfiles.rules = [
    # web UI
    "d /var/lib/kimai/cache 0770 root root - -"
    "d /var/lib/kimai/data 0770 root root - -"
    "d /var/lib/kimai/plugins 0770 root root - -"

    # database
    "d /var/lib/kimai-db 0770 root root - -"
  ];
}
