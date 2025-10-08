{ config, ... }:

let
  options = [
    "noauto"
    "rw"
    "x-gvfs-show"
    "x-systemd.automount"
    "x-systemd.mount-timeout=10"
  ];

  share = path: {
    device = "${config.lan.storage}:${path}";
    fsType = "nfs";
    options = options;
  };
in

{
  config = {
    fileSystems."/mnt/files" = share "/files";
    fileSystems."/mnt/media" = share "/media";
    fileSystems."/mnt/store" = share "/store";

    systemd.tmpfiles.rules = [
      "d /mnt/files 0755 ${config.machine.username} root"
      "d /mnt/media 0755 ${config.machine.username} root"
      "d /mnt/store 0755 ${config.machine.username} root"
    ];
  };
}
