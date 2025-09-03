{ config, pkgs, ... }:

let
  gitDerivation = pkgs.stdenv.mkDerivation rec {
    name = "git-credentials";

    src = ../secrets/git/credentials.json;
    ageKeyFile = /home/${config.machine.username}/.config/sops/age/keys.txt;

    nativeBuildInputs = [
      pkgs.sops
    ];

    unpackPhase = ''
      echo "Skipping default unpack phase"
    '';

    buildPhase = ''
      echo "Copying age key file..."
      tmpdir=$(mktemp -d)
      cp ${ageKeyFile} "$tmpdir/age-key.txt"

      echo "Decrypting the zip file..."
      export SOPS_AGE_KEY_FILE=$tmpdir/age-key.txt
      sops -d $src > credentials.json
      echo "Decryption successful."
      rm -rf "$tmpdir"
    '';

    installPhase = ''
      mv credentials.json $out
    '';
  };

  credentials = builtins.fromJSON (builtins.readFile gitDerivation);
in

{
  config = {
    home.packages = with pkgs; [
      git-credential-manager
    ];

    programs.git = {
      enable = true;

      extraConfig = {
        user.name = credentials.name;
        user.email = credentials.email;
        core.commentChar = ";";
        credential.credentialStore = "secretservice";
        credential.helper = "manager";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };

      aliases = {
        br = "branch";

        cf = "config";
        ch = "checkout";
        cm = "commit";
        cp = "cherry-pick";

        df = "diff";

        ft = "fetch";

        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\ %Creset%s%Cblue\\\ [%cn]\" --decorate --numstat";
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\ %Creset%s%Cblue\\\ [%cn]\" --decorate";

        mr = "merge";

        pl = "pull";
        ps = "push";

        rb = "rebase";
        rs = "reset";
        rt = "restore";

        sh = "stash";
        st = "status";
      };
    };
  };
}
