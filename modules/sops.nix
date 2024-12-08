{ config, ... }:

let
  permissions = {
    owner = config.machine.username;
    group = "root";
    mode = "0400";
  };

  fromBinary =
    path:
    permissions
    // {
      format = "binary";
      sopsFile = path;
    };

  fromYaml =
    path:
    permissions
    // {
      format = "yaml";
      sopsFile = path;
    };
in

# generate an age key:
# $ mkdir -p ~/.config/sops/age
# $ age-keygen -o ~/.config/sops/age/keys.txt

# update keys:
# $ sops updatekeys secrets/example.yaml

{
  sops.age.keyFile = "/home/${config.machine.username}/.config/sops/age/keys.txt";

  # git credentials
  sops.secrets."git/main" = fromBinary ../secrets/git/main.conf;
  sops.secrets."git/work" = fromBinary ../secrets/git/work.conf;

  # ssh keys
  sops.secrets."dskt/ed_25519_pub" = fromYaml ../secrets/ssh.yaml;
  sops.secrets."lpt0/ed_25519_pub" = fromYaml ../secrets/ssh.yaml;
  sops.secrets."rpi4/ed_25519_pub" = fromYaml ../secrets/ssh.yaml;

  # wireguard interfaces
  sops.secrets."es_62" = fromBinary ../secrets/wireguard/es_62.conf;
  sops.secrets."es_65" = fromBinary ../secrets/wireguard/es_65.conf;
  sops.secrets."ie_25" = fromBinary ../secrets/wireguard/ie_25.conf;
  sops.secrets."ie_36" = fromBinary ../secrets/wireguard/ie_36.conf;
  sops.secrets."uk_14" = fromBinary ../secrets/wireguard/uk_14.conf;
  sops.secrets."uk_24" = fromBinary ../secrets/wireguard/uk_24.conf;

  # system data
  sops.secrets."user/hashed_password" = fromYaml ../secrets/sys.yaml;
}
