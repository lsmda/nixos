{ config, ... }:

let
  nfs-mount-options = [
    "noauto" # disable auto-mount on boot
    "rw" # read-write permissions
    "x-gvfs-show" # show mounted filesystems on file explorer
    "x-systemd.automount" # enable on-demand mounting
    "x-systemd.mount-timeout=5" # ignore pending mounts after 5sec
  ];
in

{
  fileSystems."/mnt/files" = {
    device = "${config.lan.server}:/files";
    fsType = "nfs";
    options = nfs-mount-options;
  };

  fileSystems."/mnt/media" = {
    device = "${config.lan.server}:/media";
    fsType = "nfs";
    options = nfs-mount-options;
  };
}
