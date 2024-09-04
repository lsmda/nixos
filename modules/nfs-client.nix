{...}: let
  nfs-mount-options = [
    "noauto" # Disable auto-mount on boot
    "rw" # Read-write permissions
    "x-gvfs-show" # Show mounted filesystems on file explorer
    "x-systemd.automount" # Enable on-demand mounting
    "x-systemd.mount-timeout=5" # Ignore pending mounts after 5sec
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
}
