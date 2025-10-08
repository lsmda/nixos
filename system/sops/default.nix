{ lib, config, ... }:

let
  user = config.machine.username;
  inherit (import ../utils { inherit config lib; }) fromBinary fromYaml;
in

# generate age key:
# $ mkdir -p ~/.config/sops/age
# $ age-keygen -o ~/.config/sops/age/keys.txt

# update keys:
# $ sops updatekeys secrets/example.yaml

{
  config = {
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
  };
}
