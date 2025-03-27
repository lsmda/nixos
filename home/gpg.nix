{ pkgs, ... }:

{
  # home.packages = with pkgs; [
  #   gnupg
  #   pinentry-gtk2
  # ];

  programs.gpg.enable = true;

  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-gtk2;
  services.gpg-agent.enableNushellIntegration = true;
}
