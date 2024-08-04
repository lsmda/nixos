{pkgs, ...}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.user = {
    home.username = "user";
    home.homeDirectory = "/home/user";

    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        userName = "lsmda";
        userEmail = "contact@lsmda.pm";
        extraConfig = {
          credential.credentialStore = "secretservice";
          credential.helper = ["manager"];
        };
      };
    };

    home.packages = with pkgs; [
      vscode.fhs
    ];

    gtk.enable = true;
    gtk.iconTheme.name = "Tela-grey-dark";
    gtk.iconTheme.package = pkgs.tela-icon-theme;

    dconf.enable = true;
    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

    home.stateVersion = "24.05";
  };

  home-manager.backupFileExtension = "backup";
}
