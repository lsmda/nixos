{ ... }:
let
  client = "10.2.0.2/32";
  dns = "10.2.0.1";
  listenPort = 51820;
  privateKey = "/etc/wireguard/privatekey";
  publicKey = builtins.readFile "/etc/wireguard/publickey";
  server = "185.76.11.17"; # Public IP address
in
{
  networking.wg-quick.interfaces = {
    ES = {
      address = [ client ];
      dns = [ dns ];
      listenPort = listenPort;
      privateKeyFile = privateKey;

      peers = [
        {
          publicKey = publicKey;
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ]; # Forward all traffic through wireguard
          endpoint = "${server}:${toString listenPort}";
          persistentKeepalive = 25;
        }
      ];

      # Allow LAN connections by routing local traffic via default gateway
      postUp = ''
        ip route add 10.0.0.0/24 via 10.0.0.1
      '';
    };
  };
}
