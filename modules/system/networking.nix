{ config, lib, ... }:

let
  allowedPorts = [
    5432 # postgresql
    2049 # nfs
  ];

  localDevRange = {
    from = 5000;
    to = 5010;
  };
in

{
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = allowedPorts;
  networking.firewall.allowedUDPPorts = allowedPorts;

  networking.firewall.allowedTCPPortRanges = [ localDevRange ];
  networking.firewall.allowedUDPPortRanges = [ localDevRange ];

  networking.hostName = config.machine.hostname;
  networking.networkmanager.enable = true;

  networking.useDHCP = lib.mkDefault true;

  networking.extraHosts = ''
    192.168.0.1   router.local
    192.168.0.5   wardstone
    192.168.0.10  thornmail
    192.168.0.11  spellbook
  '';
}
