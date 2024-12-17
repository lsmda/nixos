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
    cm = "commit";
    br = "branch";
    ch = "checkout";
    cf = "config";
    rs = "reset";
    st = "status";

    ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
    ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
  };

  git.includes = [
    {
      path = toString secrets."git/main".path;
    }
    {
      condition = "hasconfig:remote.*.url:https://gitlab.com/*/digital/**";
      path = toString secrets."git/work".path;
    }
  ];
}
