{ config, lib, ... }:

let
  inherit (import ../utils { inherit config lib; }) fromBinary fromYaml withOwner;

  fqdn = "lsmda.pm";
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
    sops.secrets."cloudflare/rpi-4" = fromBinary ../secrets/cloudflare/rpi-4;

    sops.secrets."${fqdn}/key.pem" = withOwner "caddy" (fromBinary ../secrets/${fqdn}/key.pem);
    sops.secrets."${fqdn}/cert.pem" = withOwner "caddy" (fromBinary ../secrets/${fqdn}/cert.pem);

    sops.secrets."www/cv" = fromYaml ../secrets/system.yaml;
    sops.secrets."www/lsmda" = fromYaml ../secrets/system.yaml;

    www.fqdn = fqdn;

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
      '';
      virtualHosts."${fqdn}".extraConfig = ''
        tls ${secrets."${fqdn}/cert.pem".path} ${secrets."${fqdn}/key.pem".path}

        root * /var/www/${fqdn}
        encode gzip
        file_server

        log {
          output file /var/log/caddy/${fqdn}.log
          format json {
            time_format iso8601
          }
        }
      '';
      virtualHosts."*.${fqdn}".extraConfig = ''
        tls ${secrets."${fqdn}/cert.pem".path} ${secrets."${fqdn}/key.pem".path}

        @cv host cv.${fqdn}
        handle @cv {
          redir https://drive.proton.me/urls/RW1W0VRESW#YrGkMQLX4nsc 302
        }

        # refuse unknown domains
        handle {
          respond 404
        }
      '';
    };
  };
}
