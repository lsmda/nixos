{ config, ... }:

let
  options = [
    "noauto" # disable auto-mount on boot
    "rw" # read-write permissions
    "x-gvfs-show" # show mounted file systems on file explorer
    "x-systemd.automount" # enable on-demand mounting
    "x-systemd.mount-timeout=5" # ignore pending mounts after 5sec
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
