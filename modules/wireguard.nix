{ ... }@args:
{
  networking.wg-quick.interfaces = {
    ${args.name} = {
      address = [ args.client ];
      dns = [ args.dns ];
      listenPort = args.port;
      privateKeyFile = args.privateKey;

      peers = [
        {
          publicKey = args.publicKey;
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "${args.server}:${toString args.port}";
          persistentKeepalive = 25;
        }
      ];

      # Allow LAN traffic on network 10.0.0.0
      postUp = ''
        ip route add 10.0.0.0/24 via 10.0.0.1
      '';
    };
  };
}
