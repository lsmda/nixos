{ config, pkgs, ... }:

let
  secrets = config.sops.secrets;
in

{
  systemd.services.set_environment_variables = {
    script = ''
      deepseek_key=$(${pkgs.coreutils}/bin/cat ${secrets."user/deepseek".path})
      ${pkgs.fish}/bin/fish -c "set -U OPENAI_API_KEY $deepseek_key"
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
