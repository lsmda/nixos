{ config, pkgs, ... }:

let
  secrets = config.sops.secrets;
in

{
  systemd.services.ssh-authorized-keys = {
    script = ''
      SPELLBOOK_KEY=$(${pkgs.coreutils}/bin/cat ${secrets."spellbook/ed_25519_pub".path})

      # Define the authorized_keys file path
      AUTH_KEYS_FILE=~/.ssh/authorized_keys

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

      # Append the key and add a newline
      echo "$SPELLBOOK_KEY" >> "$AUTH_KEYS_FILE"
      echo "" >> "$AUTH_KEYS_FILE"  # Adds a blank line
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
