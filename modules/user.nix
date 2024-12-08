{ ... }@args:

let
  listToSet = builtins.map (name: {
    inherit name;
    value = { };
  });
in

{
  users.groups = builtins.listToAttrs (listToSet (args.extraGroups or [ ]));

  users.users.${args.username} = {
    home = args.home;
    uid = args.uid;
    isNormalUser = true;
    group = args.group;
    shell = args.shell;
    hashedPasswordFile = args.hashedPasswordFile;

    extraGroups = [
      "networkmanager"
      "wheel"
    ] ++ args.extraGroups or [ ];

    openssh.authorizedKeys.keyFiles = args.openssh.authorizedKeys.keyFiles or [ ];
  };
}
