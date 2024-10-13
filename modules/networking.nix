{ config, lib, ... }:

let
  allowedPorts = [
    5432 # postgresql
    2049 # nfs
  ];
in

{
  networking = {
    networkmanager.enable = true;

    hostName = config.machine.hostname;

    firewall.enable = true;
    firewall.allowedTCPPorts = allowedPorts;
    firewall.allowedUDPPorts = allowedPorts;

    useDHCP = lib.mkDefault true;
  };
}
