{ config, pkgs, ... }:

let
  domain = "apollo.pm";
  secrets = config.sops.secrets;
in

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.cloudflared = {
    enable = true;
    tunnels = {
      "rpi-4" = {
        credentialsFile = "${secrets."cloudflared/rpi-4".path}";
        ingress = {
          "${domain}" = "https://localhost";
          "*.${domain}" = "https://localhost";
        };
        originRequest.originServerName = "${domain}";
        default = "http_status:404";
      };
    };
  };

  services.caddy = {
    enable = true;
    environmentFile = secrets."cloudflared/env".path;
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/caddy-dns/cloudflare@v0.2.1"
        "github.com/caddy-dns/acmedns@v0.4.1"
      ];
      hash = "sha256-S4q2svO89Cma/amoe57Xl/GVwY/FvAWJNpJw1UzeYk0=";
    };
    globalConfig = ''
      default_bind 127.0.0.1 [::1]
      acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    '';
    virtualHosts."https://${domain}".extraConfig = ''
      root * /var/www/lsmda.pm
      encode gzip
      file_server

      log {
        output file /var/log/caddy/apollo.pm.log
        format json {
          time_format iso8601
        }
      }
    '';
    virtualHosts."https://*.${domain}".extraConfig = ''
      @cv host cv.${domain}
      handle @cv {
        redir https://drive.proton.me/urls/RW1W0VRESW#YrGkMQLX4nsc 302
      }

      # refuse unknown domains
      handle {
        respond 404
      }
    '';
  };
}
