{ config, ... }:

let
  simple_share = path: {
    "admin users" = config.machine.username;
    "browseable" = "yes";
    "guest ok" = "no";
    "path" = path;
    "read only" = false;
  };
in

# ios and windows use samba to connect to nfs.

{
  services.samba.enable = true;
  services.samba.openFirewall = true;

  services.samba.settings = {
    files = simple_share "/mnt/hyperx/files";
    media = simple_share "/mnt/hyperx/media";
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
    workgroup = "WORKGROUP";
  };
}
