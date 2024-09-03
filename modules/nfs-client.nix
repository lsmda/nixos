{...}: let
  nfs-mount-options = [
    "fsc" #  Enable the cache of (read-only) data pages to the local disk
    "noauto" # Disable filesystem auto-mount on boot
    "rw" # Mount filesystem as read-write
    "x-gvfs-show" # Show mounted filesystems on file explorer
    "x-systemd.automount" # enable on-demand mounting
    "x-systemd.mount-timeout=1"
    "x-systemd.idle-timeout=600" # Unmount idle partitions after 10min
  ];
in {
  fileSystems."/mnt/files" = {
    device = "10.0.0.5:/export/files";
    fsType = "nfs";
    options = nfs-mount-options;
  };

  fileSystems."/mnt/media" = {
    device = "10.0.0.5:/export/media";
    fsType = "nfs";
    options = nfs-mount-options;
  };

  boot.initrd = {
    supportedFilesystems = ["nfs"];
    kernelModules = ["nfs"];
  };
}
