{ config, lib, ... }:

let
  allowedPorts = [
    5432 # postgresql
    2049 # nfs
  ];
in

{
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = allowedPorts;
  networking.firewall.allowedUDPPorts = allowedPorts;

  networking.hostName = config.machine.hostname;
  networking.networkmanager.enable = true;

  networking.useDHCP = lib.mkDefault true;
}
