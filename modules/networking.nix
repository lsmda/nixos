{
  lib,
  machine,
  ...
}: let
  opts = lib.getAttr machine (import ../options/default.nix);

  address = opts.address;
  gateway = opts.gateway;
  hostname = opts.hostname;
  interface = opts.interface;

  allowedPorts = [
    5432 # PostgreSQL
    2049 # NFS
  ];
in {
  networking = {
    hostName = hostname;
    networkmanager.enable = true;

    firewall.enable = true;
    firewall.allowedTCPPorts = allowedPorts;
    firewall.allowedUDPPorts = allowedPorts;

    interfaces.${interface} = {
      ipv4.addresses = [
        {
          address = address;
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = {
      address = gateway;
      interface = interface;
    };
  };
}
