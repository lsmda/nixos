{ config, pkgs, ... }:

let
  inherit (pkgs) lib;
  inherit (import ../../utils { inherit config pkgs; }) fromBinary withOwner;

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
    www.fqdn = "lsmda.pm";

    sops.secrets."${fqdn}/key.pem" = withOwner "caddy" (fromBinary ./secrets/${fqdn}.key.pem);
    sops.secrets."${fqdn}/cert.pem" = withOwner "caddy" (fromBinary ./secrets/${fqdn}.cert.pem);

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
