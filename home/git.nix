{ config, ... }:

let
  secrets = config.sops.secrets;
in

{
  programs.git.enable = true;

  programs.git.extraConfig.core.commentChar = ";";
  programs.git.extraConfig.credential.credentialStore = "secretservice";
  programs.git.extraConfig.credential.helper = "manager";
  programs.git.extraConfig.init.defaultBranch = "main";
  programs.git.extraConfig.push.autoSetupRemote = true;

  programs.git.aliases = {
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

  programs.git.includes = [
    { path = toString secrets."git/main".path; }
    {
      condition = "hasconfig:remote.*.url:https://gitlab.com/*/digital/**";
      path = toString secrets."git/work".path;
    }
  ];
}
