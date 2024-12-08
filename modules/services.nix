{ config, pkgs, ... }:

let
  secrets = config.sops.secrets;
in

# secrets cannot be read during system activation phase.
# set services to read the secrets after system activation.

{
  systemd.services.git-credentials = {
    enable = true;
    description = "Set git credentials on system activation";

    script = ''
      USER=$(${pkgs.coreutils}/bin/cat "${secrets."main/user".path}")
      MAIL=$(${pkgs.coreutils}/bin/cat "${secrets."main/mail".path}")

      ${pkgs.git}/bin/git config --global user.name "$USER"
      ${pkgs.git}/bin/git config --global user.email "$MAIL"
    '';

    serviceConfig = {
      RemainAfterExit = false;
      Type = "oneshot";
      User = config.machine.username;
    };

    wantedBy = [ "multi-user.target" ];
    after = [ "system-activation.target" ];
  };
}
