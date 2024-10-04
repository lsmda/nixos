{
  config,
  lib,
  pkgs,
  ...
}:

let
  dconf = config.home.dconf;
  git-extra = config.home.git-extra;
  gtk = config.home.gtk;
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in

{
  imports = [ (import "${home-manager}/nixos") ];

  options = {
    home.dconf = {
      enable = lib.mkEnableOption "Enable dconf";
    };

    home.git-extra = {
      enable = lib.mkEnableOption "Enable git extra config";
    };

    home.gtk = {
      enable = lib.mkEnableOption "Enable gtk";
    };
  };

  config = {
    home-manager.users."user" =

      { lib, ... }:

      {
        home.username = "user";
        home.homeDirectory = "/home/user";

        services.mpris-proxy.enable = true;

        programs = {
          home-manager.enable = true;

          git =
            (import ./git.nix { })
            // lib.mkIf git-extra.enable {
              extraConfig = {
                credential.credentialStore = "secretservice";
                credential.helper = [ "manager" ];
              };
            };
        };

        dconf = lib.mkIf dconf.enable (import ./dconf.nix { inherit lib; });

        gtk = lib.mkIf gtk.enable (import ./gtk.nix { inherit pkgs; });

        home.stateVersion = "24.05";
      };

    home-manager.backupFileExtension = "backup";
  };
}
