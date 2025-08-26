{ config, lib, ... }:

let
  inherit (import ../utils { inherit config lib; }) fromBinary;

  fqdn = config.www.fqdn;
  secrets = config.sops.secrets;
in

{
  config = {
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

    services.caddy.virtualHosts."kimai.${fqdn}".extraConfig = ''
      tls ${secrets."${fqdn}/cert.pem".path} ${secrets."${fqdn}/key.pem".path}
            
      reverse_proxy localhost:8001

      log {
        output file /var/log/caddy/kimai.${fqdn}.log
        format json {
          time_format iso8601
        }
      }
    '';

    systemd.tmpfiles.rules = [
      # web UI
      "d /var/lib/kimai/data 0770 root root - -"
      "d /var/lib/kimai/plugins 0770 root root - -"

      # database
      "d /var/lib/kimai-db 0770 root root - -"
    ];
  };
}
