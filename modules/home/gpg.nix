{ pkgs, ... }:

{
  programs.gpg.enable = true;

  services = {
    gpg-agent.enable = true;
    gpg-agent.pinentryPackage = pkgs.pinentry-gtk2;
    gpg-agent.enableNushellIntegration = true;
  };
}
