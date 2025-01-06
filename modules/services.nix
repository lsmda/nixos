{ config, pkgs, ... }:

let
  secrets = config.sops.secrets;
in

{
  systemd.services.set_environment_variables = {
    script = ''
      DEEPSEEK_KEY=$(${pkgs.coreutils}/bin/cat ${secrets."user/deepseek".path})
      ${pkgs.fish}/bin/fish -c "set -Ux OPENAI_API_KEY $DEEPSEEK_KEY"
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "no";
      User = config.machine.username;
    };

    wantedBy = [ "multi-user.target" ];
    after = [ "system-activation.target" ];
  };
}
