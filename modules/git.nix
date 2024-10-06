{
  enable = true;

  userName = "lsmda";
  userEmail = "contact@lsmda.pm";

  extraConfig = {
    credential.credentialStore = "secretservice";
    credential.helper = [ "manager" ];
    core.commentChar = ";";
  };

  aliases = {
    a = "add";
    aa = "add --all";

    c = "checkout";
    cb = "checkout -b";

    s = "status";
    l = "log --oneline";

    cm = "commit -m";
    ca = "commit --amend";

    f = "fetch";
    fp = "fetch --purge"; # delete merged local branches

    bd = "branch -D"; # delete local branch
    bdr = "branch push --delete"; # delete remote branch

    pl = "pull";
    ps = "push";
    pf = "push --force-with-lease";

    rs = "reset HEAD~"; # undo last local commit
    rv = "revert";
    rt = "restore"; # discard changes at path

    mr = "merge";
    rb = "rebase";

    st = "stash";
    sd = "stash drop";
    sp = "stash pop";
    sa = "stash push --all";
  };
}
