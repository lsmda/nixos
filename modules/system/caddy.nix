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
      "a12fef7a-4df6-40c8-beb7-5f2bca981024" = {
        credentialsFile = "${secrets."cloudflared/lsmda.pm".path}";
        ingress = {
          "lsmda.pm" = "http://localhost:5000";
          "*.lsmda.pm" = "http://localhost:5001";
        };
        originRequest.httpHostHeader = "localhost";
        default = "http_status:404";
      };
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://localhost:80".extraConfig = ''
        bind 127.0.0.1 [::1]
        respond "{ \"status\": \"OK\" }"
      '';
      "http://localhost:5000".extraConfig = ''
        bind 127.0.0.1 [::1]

        root * /var/www/lsmda.pm
        encode gzip
        file_server

        log {
          output file /var/log/caddy/lsmda.pm
        }
      '';
      "http://localhost:5001".extraConfig = ''
        bind 127.0.0.1 [::1]

        @resume {
          header X-Forwarded-Host resume.lsmda.pm
        }

        handle @resume {
          reverse_proxy http://localhost:5000
        }

        # refuse unknown subdomains
        handle {
          respond 404
        }

        log {
          output file /var/log/caddy/test.lsmda.pm
        }
      '';
    };
  };
}
