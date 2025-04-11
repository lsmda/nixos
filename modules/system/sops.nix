{ config, ... }:

let
  user = config.machine.username;

  sops_file = path: {
    mode = "0400";
    owner = user;
    sopsFile = path;
  };

  from_yaml = path: sops_file path // { format = "yaml"; };
  from_binary = path: sops_file path // { format = "binary"; };
in

# generate age key:
# $ mkdir -p ~/.config/sops/age
# $ age-keygen -o ~/.config/sops/age/keys.txt

# update keys:
# $ sops updatekeys secrets/example.yaml

{
  sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

  # user's hashed password
  sops.secrets."deepseek" = from_yaml ../../secrets/system.yaml;
  sops.secrets."password" = from_yaml ../../secrets/system.yaml;

  # ssh public keys
  sops.secrets."ed25519/spellbook" = from_yaml ../../secrets/system.yaml;
  sops.secrets."ed25519/thornmail" = from_yaml ../../secrets/system.yaml;
  sops.secrets."ed25519/wardstone" = from_yaml ../../secrets/system.yaml;

  # git credentials
  sops.secrets."git/main" = from_binary ../../secrets/git/main.conf;
  sops.secrets."git/work" = from_binary ../../secrets/git/work.conf;

  # wireguard configuration files
  sops.secrets."es_62" = from_binary ../../secrets/wireguard/es_62.conf;
  sops.secrets."es_65" = from_binary ../../secrets/wireguard/es_65.conf;
  sops.secrets."ie_25" = from_binary ../../secrets/wireguard/ie_25.conf;
  sops.secrets."ie_36" = from_binary ../../secrets/wireguard/ie_36.conf;
  sops.secrets."uk_14" = from_binary ../../secrets/wireguard/uk_14.conf;
  sops.secrets."uk_24" = from_binary ../../secrets/wireguard/uk_24.conf;
}
