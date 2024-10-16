{
  config,
  interface,
  server,
  port,
  client,
  dns,
  publicKey,
  privateKeyFile,
  ...
}:

{
  networking.wg-quick.interfaces = {
    ${interface} = {
      address = [ client ];
      dns = [ dns ];
      listenPort = port;
      privateKeyFile = privateKeyFile;

      peers = [
        {
          publicKey = publicKey;
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "${server}:${toString port}";
          persistentKeepalive = 25;
        }
      ];

      # allow LAN traffic
      postUp = ''
        ip route add ${config.lan.network}/24 via ${config.lan.gateway}
      '';
    };
  };
}
