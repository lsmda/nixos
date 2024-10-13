{ config, ... }:

{
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.keyFile = "/home/${config.machine.username}/.config/sops/age/keys.txt";

  sops.secrets."user/hashedPassword" = { };

  sops.secrets."ssh/laptop" = { };
  sops.secrets."ssh/desktop" = { };

  sops.secrets."wireguard/es_30/privateKey" = { };
  sops.secrets."wireguard/es_45/privateKey" = { };
}
