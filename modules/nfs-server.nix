{...}: {
  services.nfs.server.enable = true;

  services.nfs.server.exports = ''
    /share         10.0.0.0/24(rw,fsid=0,no_subtree_check)
    /share/files   10.0.0.0/24(rw,nohide,insecure,no_subtree_check)
    /share/media   10.0.0.0/24(rw,nohide,insecure,no_subtree_check)
  '';
}
