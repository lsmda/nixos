{ config, pkgs, ... }:

let
  secrets = config.sops.secrets;
in

{
  systemd.services.ssh-authorized-keys = {
    script = ''
      SPELLBOOK_KEY=$(${pkgs.coreutils}/bin/cat ${secrets."spellbook/ed_25519_pub".path})
      echo $SPELLBOOK_KEY >> ~/.ssh/authorized_keys
      echo \n >> ~/.ssh/authorized_keys
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "no";
      User = config.machine.username;
    };

    wantedBy = [ "multi-user.target" ];
    after = [ "system-activation.target" ];
  };

  # systemd.services.environment-variables = {
  #   script = ''
  #     DEEPSEEK_KEY=$(${pkgs.coreutils}/bin/cat ${secrets."user/deepseek".path})
  #     ${pkgs.fish}/bin/fish -c "set -Ux OPENAI_API_KEY $DEEPSEEK_KEY"
  #   '';
  #
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = "no";
  #     User = config.machine.username;
  #   };
  #
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "system-activation.target" ];
  # };
}
