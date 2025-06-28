{ config, ... }:

let
  share = path: {
    device = path;
    fsType = "none";
    options = [ "bind" ];
  };
in

{
  fileSystems."/srv/nfs/files" = share "/mnt/hyperx/files";
  fileSystems."/srv/nfs/media" = share "/mnt/hyperx/media";

  services.nfs.server = {
    enable = true;
    exports = ''
      /srv/nfs         ${config.lan.network}/24(rw,fsid=0,no_subtree_check)
      /srv/nfs/files   ${config.lan.network}/24(rw,no_subtree_check,sync)
      /srv/nfs/media   ${config.lan.network}/24(rw,no_subtree_check,sync)
    '';
  };

  systemd.tmpfiles.rules = [
    "d /srv/nfs/files 0644 ${config.machine.username} root"
    "d /srv/nfs/media 0644 ${config.machine.username} root"
  ];
}
