{ config, ... }:

let
  domain = "lsmda.pm";
  secrets = config.sops.secrets;
in

{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "rpi-4" = {
        credentialsFile = "${secrets."cloudflare/rpi-4".path}";
        ingress = {
          "${domain}" = "https://127.0.0.1";
          "*.${domain}" = "https://127.0.0.1";
        };
        originRequest.originServerName = "${domain}";
        default = "http_status:404";
      };
    };
  };

  services.caddy = {
    enable = true;
    globalConfig = ''
      default_bind 127.0.0.1 [::1]
    '';
    virtualHosts."${domain}".extraConfig = ''
      root * /var/www/${domain}
      encode gzip
      file_server

      tls ${secrets."lsmda.pm/cert.pem".path} ${secrets."lsmda.pm/key.pem".path}

      log {
        output file /var/log/caddy/${domain}.log
        format json {
          time_format iso8601
        }
      }
    '';
    virtualHosts."*.${domain}".extraConfig = ''
      tls ${secrets."lsmda.pm/cert.pem".path} ${secrets."lsmda.pm/key.pem".path}

      @cv host cv.${domain}
      handle @cv {
        redir https://drive.proton.me/urls/RW1W0VRESW#YrGkMQLX4nsc 302
      }

      @kimai host kimai.${domain}
      handle @kimai {
        reverse_proxy localhost:8001
      }

      # refuse unknown domains
      handle {
        respond 404
      }
    '';
  };
}
