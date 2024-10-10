{ config, ... }:

{
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.keyFile = "/home/${config.machine.username}/.config/sops/age/keys.txt";

  sops.secrets.git_user = { };
  sops.secrets.git_email = { };
  sops.secrets.hashed_password = { };
}
