{...}: let
  nfs-mount-options = [
    "fsc" #  Enable cache of (read-only) data pages to the local disk
    "noauto" # Disable auto-mount on boot
    "rw" # Read-write permissions
    "x-gvfs-show" # Show mounted filesystems on file explorer
    "x-systemd.automount" # Enable on-demand mounting
    "x-systemd.mount-timeout=1"
    "x-systemd.idle-timeout=600" # Unmount idle partitions after 10min
  ];
in {
  fileSystems."/mnt/files" = {
    device = "10.0.0.5:/files";
    fsType = "nfs";
    options = nfs-mount-options;
  };

  fileSystems."/mnt/media" = {
    device = "10.0.0.5:/media";
    fsType = "nfs";
    options = nfs-mount-options;
  };

  boot.initrd.kernelModules = ["nfs"];
  boot.initrd.supportedFilesystems = ["nfs"];
}
