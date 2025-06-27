{ config, ... }:

let
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
      "66b7e9d1-4801-4a7b-9422-62096ff78b25" = {
        credentialsFile = "${secrets."cloudflared/apollo.pm".path}";
        ingress = {
          "apollo.pm" = "http://localhost:5001";
          "*.apollo.pm" = "http://localhost:5001";
        };
        originRequest.httpHostHeader = "localhost";
        default = "http_status:404";
      };
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."http://localhost:5000".extraConfig = ''
      bind 127.0.0.1 [::1]

      root * /var/www/lsmda.pm
      encode gzip
      file_server

      log {
        output file /var/log/caddy/lsmda.pm
        format json {
          time_format iso8601
        }
      }
    '';
    virtualHosts."http://localhost:5001".extraConfig = ''
        bind 127.0.0.1 [::1]

        @cv header X-Forwarded-Host cv.apollo.pm
        handle @cv {
          redir https://drive.proton.me/urls/RW1W0VRESW#YrGkMQLX4nsc 302
        }

        @root header X-Forwarded-Host apollo.pm
      	handle @root {
      		reverse_proxy http://localhost:5000
      	}

        # refuse unknown domains
        handle {
          respond 404
        }
    '';
  };
}
