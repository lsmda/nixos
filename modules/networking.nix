{
  hostname ? "device",
  allowedPorts ? [
    5432 # PostgreSQL
    2049 # NFS
  ],
  ...
}: {
  networking = {
    hostName = hostname;
    networkmanager.enable = true;

    firewall.enable = true;
    firewall.allowedTCPPorts = allowedPorts;
    firewall.allowedUDPPorts = allowedPorts;
  };
}
