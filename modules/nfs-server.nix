{ ... }:
{
  services.nfs.server.enable = true;

  fileSystems."/share/files" = {
    device = "/mnt/hyperx/files";
    label = "files";
    fsType = "none";
    options = [
      "bind"
      "users"
    ];
  };

  fileSystems."/share/media" = {
    device = "/mnt/hyperx/media";
    label = "media";
    fsType = "none";
    options = [
      "bind"
      "users"
    ];
  };

  services.nfs.server.exports = ''
    /share         10.0.0.0/24(rw,fsid=0,no_subtree_check)
    /share/files   10.0.0.0/24(rw,nohide,insecure,no_subtree_check)
    /share/media   10.0.0.0/24(rw,nohide,insecure,no_subtree_check)
  '';
}
