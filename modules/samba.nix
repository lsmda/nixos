{ ... }:

let
  simpleShare = path: {
    "admin users" = "user";
    "browseable" = "yes";
    "guest ok" = "no";
    "path" = path;
    "read only" = false;
  };
in

# samba is used to access the nfs server on ios and windows.

{
  services.samba.enable = true;
  services.samba.openFirewall = true;

  services.samba.settings = {
    files = simpleShare "/mnt/hyperx/files";
    media = simpleShare "/mnt/hyperx/media";
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
    workgroup = "WORKGROUP";
  };
}
