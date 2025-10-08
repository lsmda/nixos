{ pkgs, ... }:

{
  config = {
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-gtk2;
      enableNushellIntegration = true;
    };
  };
}
