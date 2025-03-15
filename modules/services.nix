{ config, pkgs, ... }:

let
  secrets = config.sops.secrets;
in

{
  systemd.services.ssh-authorized-keys = {
    script = ''
      AUTH_KEYS_FILE=~/.ssh/authorized_keys

      SPELLBOOK_KEY=$(${pkgs.coreutils}/bin/cat ${secrets."spellbook/ed_25519_pub".path})
      THORNMAIL_KEY=$(${pkgs.coreutils}/bin/cat ${secrets."thornmail/ed_25519_pub".path})

      # Check if directory exists, create if it doesn't
      [ -d ~/.ssh ] || mkdir -p ~/.ssh

      # If file doesn't exist, create it
      # If it does exist, clear its contents
      if [ ! -f "$AUTH_KEYS_FILE" ]; then
        touch "$AUTH_KEYS_FILE"
        chmod 600 "$AUTH_KEYS_FILE"
      else
        : > "$AUTH_KEYS_FILE"  # This clears the file contents
      fi

      echo "$SPELLBOOK_KEY" >> "$AUTH_KEYS_FILE"
      echo "$THORNMAIL_KEY" >> "$AUTH_KEYS_FILE"
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
