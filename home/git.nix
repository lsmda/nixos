{ config, ... }:

let
  secrets = config.sops.secrets;
in

{
  git.enable = true;

  git.extraConfig.core.commentChar = ";";
  git.extraConfig.credential.credentialStore = "secretservice";
  git.extraConfig.credential.helper = "manager";
  git.extraConfig.init.defaultBranch = "main";
  git.extraConfig.push.autoSetupRemote = true;

  git.aliases = {
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

  git.includes = [
    { path = toString secrets."git/main".path; }
    {
      condition = "hasconfig:remote.*.url:https://gitlab.com/*/digital/**";
      path = toString secrets."git/work".path;
    }
  ];
}
