{
  # whether to start the openssh agent when you log in.
  #
  # the openssh agent remembers private keys for you so
  # that you don’t have to type in passphrases every time you make an ssh connection.
  #
  # use ssh-add to add a key to the agent.
  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
  };
}
