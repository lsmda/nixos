{ machine, ... }:
let
  allowedPorts = [
    5432 # PostgreSQL
    2049 # nfs
  ];
in
{
  networking = {
    networkmanager.enable = true;

    hostName = machine;

    firewall.enable = true;
    firewall.allowedTCPPorts = allowedPorts;
    firewall.allowedUDPPorts = allowedPorts;
  };
}
