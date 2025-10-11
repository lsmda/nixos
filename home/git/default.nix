{ config, pkgs, ... }:

let
  gitDerivation = pkgs.stdenv.mkDerivation rec {
    name = "git-credentials";

    src = ../../secrets/git/credentials.json;
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
      difftastic
      git-credential-manager
    ];

    programs.git = {
      enable = true;

      # difftastic.enable = true;

      extraConfig = {
        credential.credentialStore = "secretservice";
        credential.helper = "manager";

        diff.external = "difft";
        diff.tool = "difftastic";

        difftool.prompt = false;
        # difftool.difftastic.cmd = "difft \"$LOCAL\" \"$REMOTE\"";
        difftool.difftastic.cmd = "difft \"$MERGED\" \"$LOCAL\" \"abcdef1\" \"100644\" \"$REMOTE\" \"abcdef2\" \"100644\"";

        init.defaultBranch = "main";

        pager.difftool = true;
        push.autoSetupRemote = true;

        user.name = credentials.name;
        user.email = credentials.email;
      };

      aliases = {
        br = "branch";

        cf = "config";
        ch = "checkout";
        cl = "clean";
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

    programs.lazygit = {
      enable = true;
      settings = {
        git.paging.externalDiffCommand = "difft";
        gui.showListFooter = false;
        gui.showRandomTip = false;
        gui.showCommandLog = false;
        gui.showBottomLine = false;
        gui.nerdFontsVersion = 3;
        gui.border = "single";
        quitOnTopLevelReturn = true;
        keybinding = {
          universal = {
            quit = "<esc>";
          };
        };
      };
    };
  };
}
