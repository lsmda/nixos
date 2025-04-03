{ config, ... }:

let
  user = config.machine.username;

  attributes = {
    owner = user;
    group = "root";
    mode = "0400";
  };

  sops_file = path: { sopsFile = path; };

  yaml = path: sops_file path // { format = "yaml"; };
  binary = path: sops_file path // { format = "binary"; };

  from_yaml = path: yaml path // attributes;
  from_binary = path: binary path // attributes;
in

# generate age key:
# $ mkdir -p ~/.config/sops/age
# $ age-keygen -o ~/.config/sops/age/keys.txt

# update keys:
# $ sops updatekeys secrets/example.yaml

{
  sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

  # user's hashed password
  sops.secrets."user/password" = from_yaml ../../secrets/sys.yaml;
  sops.secrets."user/deepseek" = from_yaml ../../secrets/sys.yaml;

  # ssh public keys
  sops.secrets."spellbook/ed_25519_pub" = from_yaml ../../secrets/ssh.yaml;
  sops.secrets."thornmail/ed_25519_pub" = from_yaml ../../secrets/ssh.yaml;
  sops.secrets."wardstone/ed_25519_pub" = from_yaml ../../secrets/ssh.yaml;

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
