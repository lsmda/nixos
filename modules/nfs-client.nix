{ config, ... }:

let
  options = [
    "noauto" # disable auto-mount on boot
    "rw" # read-write permissions
    "x-gvfs-show" # show mounted filesystems on file explorer
    "x-systemd.automount" # enable on-demand mounting
    "x-systemd.mount-timeout=5" # ignore pending mounts after 5sec
  ];

  simple_share = path: {
    device = "${config.lan.storage}:${path}";
    fsType = "nfs";
    options = options;
  };
in

{
  fileSystems."/mnt/files" = simple_share "/files";
  fileSystems."/mnt/media" = simple_share "/media";
}
