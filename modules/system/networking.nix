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
  options = {
    lan.network = lib.mkOption {
      type = lib.types.str;
      description = "Local network address";
    };

    lan.gateway = lib.mkOption {
      type = lib.types.str;
      description = "Local network gateway address";
    };

    lan.storage = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Local network server address";
    };
  };

  config = {
    lan.network = "192.168.0.0";
    lan.gateway = "192.168.0.1";
    lan.storage = "192.168.0.5";

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = allowedPorts;
    networking.firewall.allowedUDPPorts = [ ];

    networking.firewall.allowedTCPPortRanges = [ localDevRange ];
    networking.firewall.allowedUDPPortRanges = [ ];

    networking.hostName = config.machine.hostname;
    networking.networkmanager.enable = true;

    networking.useDHCP = lib.mkDefault true;

    networking.extraHosts = ''
      192.168.0.1   router.local
      192.168.0.5   wardstone
      192.168.0.10  thornmail
      192.168.0.11  spellbook
    '';
  };
}
