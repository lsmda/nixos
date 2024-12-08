{ config, pkgs, ... }:

let
  secrets = config.sops.secrets;
in

{
  git = {
    enable = true;

    extraConfig = {
      core.commentChar = ";";
      credential.credentialStore = "secretservice";
      credential.helper = "manager";
      init.defaultBranch = "main";
    };

    aliases = {
      creds = "!f() {
                case $1 in
                  main)
                    GIT_USER=$(${pkgs.coreutils}/bin/cat ${secrets."main/user".path})
                    GIT_MAIL=$(${pkgs.coreutils}/bin/cat ${secrets."main/mail".path})
                  ;;
                  work)
                    GIT_USER=$(${pkgs.coreutils}/bin/cat ${secrets."work/user".path})
                    GIT_MAIL=$(${pkgs.coreutils}/bin/cat ${secrets."work/mail".path})
                  ;;
                  *)
                    echo \"Invalid credential type. Use main or work.\"
                  ;;
                esac;
                git config --local --replace-all user.name \"$GIT_USER\"
                git config --local --replace-all user.email \"$GIT_MAIL\"
              }; f";
    };
  };
}
