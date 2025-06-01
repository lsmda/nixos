{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;
    virtualHosts."http://${config.lan.storage}:80".extraConfig = ''
      respond "{\"status\": \"operational\", \"host\": \"${config.machine.hostname}\"}"
    '';
  };
}
