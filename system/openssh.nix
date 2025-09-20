{ lib, ... }:

{
  options = {
    ssh-key.frostbite = lib.mkOption {
      type = lib.types.str;
    };
    ssh-key.spellbook = lib.mkOption {
      type = lib.types.str;
    };
    ssh-key.thornmail = lib.mkOption {
      type = lib.types.str;
    };
    ssh-key.wardstone = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    networking.firewall.allowedTCPPorts = [ ];
    networking.firewall.allowedUDPPortRanges = [
      {
        # mosh
        from = 60000;
        to = 61000;
      }
    ];

    # whether to start the openssh agent when you log in.
    #
    # the openssh agent remembers private keys for you so that you don’t
    # have to type in passphrases every time you make an ssh connection.
    #
    # use ssh-add to add a key to the agent.
    programs.ssh.startAgent = true;

    # faster version os SSH
    programs.mosh.enable = true;

    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        StreamLocalBindUnlink = "yes"; # auto remove stale sockets
      };
    };

    ssh-key = {
      frostbite = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5TSKvFG/h8aL9+nEKgsoi32s0Jimvhg0TIPcZ1a5dO contact@lsmda.pm";
      spellbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN25GOi1lQySmv4qRr9fyM1QCbr2Rw3+TqySs8ItbP/h contact@lsmda.pm";
      thornmail = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHx/Kp2acbibKMmvBWLKfXLwtVqGCUwq+FNIY1VGsp0F contact@lsmda.pm";
      wardstone = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtrmraahn6VySFIkRReIY4KksV76zIja4SLP/H1/PBX contact@lsmda.pm";
    };
  };
}
