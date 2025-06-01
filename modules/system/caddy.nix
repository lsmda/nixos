{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;
    virtualHosts."http://192.168.0.5:80".extraConfig = ''
      respond "{\"status\": \"operational\", \"host\": \"${config.machine.hostname}\"}"
    '';
  };
}
