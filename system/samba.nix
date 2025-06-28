let
  share = path: {
    "path" = path;
    "guest ok" = "no";
    "browseable" = "yes";
    "writeable" = "yes";
  };
in

# ios and windows use samba to connect to nfs.

{
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      files = share "/mnt/hyperx/files";
      media = share "/mnt/hyperx/media";
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
    workgroup = "WORKGROUP";
  };
}
