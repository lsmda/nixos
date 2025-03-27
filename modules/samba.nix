{ config, ... }:

let
  simple_share = path: {
    "path" = path;
    "guest ok" = "no";
    "browseable" = "yes";
    "writeable" = "yes";
    "fruit:nfs_aces" = "no";
    "admin users" = config.machine.username;
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
