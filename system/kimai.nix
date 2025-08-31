{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ../utils { inherit config lib; }) fromBinary fromFile fromYaml;

  fqdn = config.www.fqdn;
  secrets = config.sops.secrets;
in

{
  config = {
    sops.secrets."restic/password" = fromYaml ../secrets/system.yaml;

    sops.secrets."kimai" = fromBinary ../secrets/kimai/kimai // {
      restartUnits = [ "podman-kimai.service" ];
    };

    sops.secrets."kimai-db" = fromBinary ../secrets/kimai/kimai-db // {
      restartUnits = [ "podman-kimai-db.service" ];
    };

    sops.secrets."local.yaml" = fromFile (fromYaml ../secrets/kimai/local.yaml) // {
      restartUnits = [ "podman-kimai.service" ];
    };

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
        "${secrets."local.yaml".path}:/opt/kimai/config/packages/local.yaml:ro"

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

    systemd.tmpfiles.rules =
      let
        importBundlePlugin = pkgs.stdenv.mkDerivation {
          name = "ImportBundle-2.20.0";
          src = ../assets/ImportBundle-2.20.0.zip;

          nativeBuildInputs = [
            pkgs.unzip
          ];

          unpackPhase = ''
            unzip $src;
          '';

          installPhase = ''
            mkdir -p $out
            cp -r ImportBundle-2.20.0/* $out
          '';
        };
      in
      [
        # web UI
        "d /var/lib/kimai/data 0770 root root - -"
        "d /var/lib/kimai/plugins 0770 root root - -"

        # plugins
        "C /var/lib/kimai/plugins/ImportBundle-2.20.0 0770 root root - ${importBundlePlugin}"

        # database
        "d /var/lib/kimai-db 0770 root root - -"
      ];

    services.restic.backups = {
      kimai = {
        initialize = true;
        repository = "/srv/nfs/store/kimai";

        user = "root";
        passwordFile = secrets."restic/password".path;

        paths = [
          "/var/lib/kimai/data"
          "/var/lib/kimai/plugins"
          "/var/lib/kimai-db"
        ];

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 2"
          "--keep-monthly 1"
        ];

        timerConfig = {
          OnCalendar = "01:00";
          RandomizedDelaySec = "30m";
        };
      };
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
  };
}
