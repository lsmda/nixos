{ config, ... }:

let
  permissions = {
    owner = config.machine.username;
    group = "root";
    mode = "0400";
  };

  binarySopsFile =
    path:
    permissions
    // {
      format = "binary";
      sopsFile = path;
    };

  yamlSopsFile =
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
  sops.secrets."main/user" = yamlSopsFile ../secrets/git.yaml;
  sops.secrets."main/mail" = yamlSopsFile ../secrets/git.yaml;
  sops.secrets."work/user" = yamlSopsFile ../secrets/git.yaml;
  sops.secrets."work/mail" = yamlSopsFile ../secrets/git.yaml;

  # ssh keys
  sops.secrets."dskt/ed_25519_pub" = yamlSopsFile ../secrets/ssh.yaml;
  sops.secrets."lpt0/ed_25519_pub" = yamlSopsFile ../secrets/ssh.yaml;
  sops.secrets."rpi4/ed_25519_pub" = yamlSopsFile ../secrets/ssh.yaml;

  # wireguard interfaces
  sops.secrets."es_62" = binarySopsFile ../secrets/wireguard/es_62.conf;
  sops.secrets."es_65" = binarySopsFile ../secrets/wireguard/es_65.conf;
  sops.secrets."ie_25" = binarySopsFile ../secrets/wireguard/ie_25.conf;
  sops.secrets."ie_36" = binarySopsFile ../secrets/wireguard/ie_36.conf;

  # system data
  sops.secrets."user/hashed_password" = yamlSopsFile ../secrets/sys.yaml;
}
