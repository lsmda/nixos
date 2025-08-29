{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      git-credential-manager
    ];

    programs.git = {
      enable = true;

      extraConfig = {
        user.name = "lsmda";
        user.email = "contact@lsmda.pm";
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

        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\ %Creset%s%Cblue\\\ [%cn]\" --decorate --numstat";
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\ %Creset%s%Cblue\\\ [%cn]\" --decorate";

        mr = "merge";

        rb = "rebase";
        rs = "reset";
        rt = "restore";

        st = "status";
      };
    };
  };
}
