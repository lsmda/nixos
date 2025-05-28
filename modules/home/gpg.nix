{ pkgs, ... }:

{
  programs.gpg.enable = true;

  services = {
    gpg-agent.enable = true;
    gpg-agent.pinentry.package = pkgs.pinentry-gtk2;
    gpg-agent.enableNushellIntegration = true;
  };
}
