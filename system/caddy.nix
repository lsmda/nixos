{ config, lib, ... }:

let
  inherit (import ../utils { inherit config lib; }) fromYaml;

  fqdn = config.www.fqdn;
  secrets = config.sops.secrets;
in

{
  options = {
    www.fqdn = lib.mkOption {
      type = lib.types.str;
      description = "Public domain name.";
    };
  };

  config = {
    sops.secrets."www/cv" = fromYaml ../secrets/system.yaml;
    sops.secrets."www/lsmda" = fromYaml ../secrets/system.yaml;

    www.fqdn = secrets."www/lsmda";

    services.cloudflared = {
      enable = true;
      tunnels = {
        "rpi-4" = {
          credentialsFile = "${secrets."cloudflare/rpi-4".path}";
          ingress = {
            "${fqdn}" = "https://127.0.0.1";
            "*.${fqdn}" = "https://127.0.0.1";
          };
          originRequest.originServerName = "${fqdn}";
          default = "http_status:404";
        };
      };
    };

    services.caddy = {
      enable = true;
      globalConfig = ''
        default_bind 127.0.0.1 [::1]

        (certs) {
          tls ${secrets."${fqdn}/cert.pem".path} ${secrets."${fqdn}/key.pem".path}
        }
      '';
      virtualHosts."${fqdn}".extraConfig = ''
        import (certs)

        root * /var/www/${fqdn}
        encode gzip
        file_server

        log {
          output file /var/log/${fqdn}.log
          format json {
            time_format iso8601
          }
        }
      '';
      virtualHosts."*.${fqdn}".extraConfig = ''
        import (certs)

        @cv host cv.${fqdn}
        handle @cv {
          redir ${secrets."www/cv"} 302
        }

        # refuse unknown domains
        handle {
          respond 404
        }
      '';
    };
  };
}
