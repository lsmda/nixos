{
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
      };
    };
  };
}
