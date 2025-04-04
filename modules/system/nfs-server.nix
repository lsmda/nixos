{ config, ... }:

let
  share = path: {
    device = path;
    fsType = "none";
    options = [ "bind" ];
  };
in

{
  services.nfs.server.enable = true;

  fileSystems."/share/files" = share "/mnt/hyperx/files";
  fileSystems."/share/media" = share "/mnt/hyperx/media";

  services.nfs.server.exports = ''
    /share         ${config.lan.network}/24(rw,fsid=0,no_subtree_check)
    /share/files   ${config.lan.network}/24(rw,no_subtree_check,sync)
    /share/media   ${config.lan.network}/24(rw,no_subtree_check,sync)
  '';
}
