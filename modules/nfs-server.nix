{ config, ... }:

let
  simpleShare = path: {
    device = path;
    fsType = "none";
    options = [ "bind" ];
  };
in

{
  services.nfs.server.enable = true;

  fileSystems."/share/files" = simpleShare "/mnt/hyperx/files";
  fileSystems."/share/media" = simpleShare "/mnt/hyperx/files";

  services.nfs.server.exports = ''
    /share         ${config.lan.network}/24(rw,fsid=0,no_subtree_check)
    /share/files   ${config.lan.network}/24(rw,nohide,insecure,no_subtree_check)
    /share/media   ${config.lan.network}/24(rw,nohide,insecure,no_subtree_check)
  '';
}