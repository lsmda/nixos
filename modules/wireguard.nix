{pkgs, ...}: {
  networking.wg-quick.interfaces = let
    client = "10.2.0.2/32";
    dns = "10.2.0.1";
    listen_port = 51820;
    private_key_file = "/etc/wireguard/privatekey";
    public_key = builtins.readFile "/etc/wireguard/publickey";
    server = "130.195.250.98";
  in {
    wg0 = {
      address = [client];
      dns = [dns];
      listenPort = listen_port;
      privateKeyFile = private_key_file;

      peers = [
        {
          publicKey = public_key;
          allowedIPs = [
            "0.0.0.0/0"
            "10.0.0.0/24"
          ];
          endpoint = "${server}:${toString listen_port}";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
