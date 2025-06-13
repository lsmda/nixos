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
        ingress."lsmda.pm" = "http://localhost:5000";
        originRequest.httpHostHeader = "localhost";
        default = "http_status:404";
      };
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://localhost:80".extraConfig = ''
        respond "{\"status\": \"operational\", \"host\": \"${config.machine.hostname}\"}"
      '';
      "http://localhost:5000".extraConfig = ''
        root * /var/www/lsmda.pm
        file_server
        encode gzip
        log {
          output file /var/log/caddy/lsmda-access.log
        }
      '';
    };
  };
}
