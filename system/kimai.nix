{ config, lib, ... }:

let
  inherit (import ../utils { inherit config lib; }) fromBinary;
  secrets = config.sops.secrets;
in

{
  sops.secrets."kimai" = fromBinary ../secrets/kimai/kimai;
  sops.secrets."kimai-db" = fromBinary ../secrets/kimai/kimai-db;

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
      "/mnt/kimai/cache:/opt/kimai/var/cache"
      "/mnt/kimai/data:/opt/kimai/var/data"
      "/mnt/kimai/packages:/opt/kimai/config/packages"
      "/mnt/kimai/plugins:/opt/kimai/var/plugins"
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
      "/mnt/kimai-db:/var/lib/mysql"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/kimai/cache 0755 root root"
    "d /mnt/kimai/data 0755 root root"
    "d /mnt/kimai/packages 0755 root root"
    "d /mnt/kimai/plugins 0755 root root"
    "d /mnt/kimai-db 0755 root root"
  ];
}
