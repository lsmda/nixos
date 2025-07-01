{ config, ... }:

let
  user = config.machine.username;

  sopsFile = path: {
    mode = "0400";
    owner = user;
    sopsFile = path;
  };

  fromYaml = path: sopsFile path // { format = "yaml"; };
  fromBinary = path: sopsFile path // { format = "binary"; };

  withOwner = owner: set: set // { owner = owner; };
in

# generate age key:
# $ mkdir -p ~/.config/sops/age
# $ age-keygen -o ~/.config/sops/age/keys.txt

# update keys:
# $ sops updatekeys secrets/example.yaml

{
  sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

  # user's hashed password
  sops.secrets."deepseek" = fromYaml ../secrets/system.yaml;
  sops.secrets."password" = fromYaml ../secrets/system.yaml;

  # wireguard configuration files
  sops.secrets."es_62" = fromBinary ../secrets/wireguard/es_62.conf;
  sops.secrets."es_65" = fromBinary ../secrets/wireguard/es_65.conf;
  sops.secrets."ie_25" = fromBinary ../secrets/wireguard/ie_25.conf;
  sops.secrets."ie_36" = fromBinary ../secrets/wireguard/ie_36.conf;
  sops.secrets."uk_14" = fromBinary ../secrets/wireguard/uk_14.conf;
  sops.secrets."uk_24" = fromBinary ../secrets/wireguard/uk_24.conf;

  # cloudflare tunnel
  sops.secrets."cloudflared/env" = fromBinary ../secrets/cloudflared/env;
  sops.secrets."cloudflared/rpi-4" = fromBinary ../secrets/cloudflared/rpi-4;
  sops.secrets."cloudflared/cert.pem" = fromBinary ../secrets/cloudflared/cert.pem;

  sops.secrets."apollo.pm/key.pem" = withOwner "caddy" (fromBinary ../secrets/apollo.pm/key.pem);
  sops.secrets."apollo.pm/cert.pem" = withOwner "caddy" (fromBinary ../secrets/apollo.pm/cert.pem);
}
