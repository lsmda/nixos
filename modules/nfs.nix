{...}: {
  services.rpcbind.enable = true;

  services.nfs.server = {
    enable = true;
    createMountPoints = true;

    exports = ''
      /export        10.0.0.0/24(rw,fsid=0,no_subtree_check)
      /export/files  10.0.0.0/24(rw,nohide,insecure,no_subtree_check)
    '';

    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
  };

  networking.firewall = let
    ports = [111 2049 4000 4001 4002 20048];
  in {
    enable = true;
    allowedTCPPorts = ports;
    allowedUDPPorts = ports;
  };
}
