{ config, ... }:

let
  allowedPorts = [
    5432 # postgresql
    2049 # nfs
  ];
  hostname = config.machine.hostname;
in

{
  networking = {
    networkmanager.enable = true;

    hostName = hostname;

    firewall.enable = true;
    firewall.allowedTCPPorts = allowedPorts;
    firewall.allowedUDPPorts = allowedPorts;
  };
}
