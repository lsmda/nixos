{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.home;
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

        programs = {
          home-manager.enable = true;

          git = lib.mkMerge [
            (import ./git.nix)

            (lib.mkIf cfg.git-extra.enable {
              extraConfig = {
                credential.credentialStore = "secretservice";
                credential.helper = [ "manager" ];
              };
            })
          ];
        };

        dconf = lib.mkIf cfg.dconf.enable (import ./dconf.nix { inherit lib; });

        gtk = lib.mkIf cfg.gtk.enable (import ./gtk.nix { inherit pkgs; });

        home.stateVersion = "24.05";
      };

    home-manager.backupFileExtension = "backup";
  };
}
