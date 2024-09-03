{pkgs, ...}: {
  imports = let
    hostname = {hostname = "pi";};
    password = {users.users."user".password = "password";};
    home = {
      home-manager.users.user = {
        programs = null;
        gtk.enable = false;
        dconf.enable = false;
      };
    };
  in [
    ./hardware-configuration.nix

    ../../modules/nfs-server.nix
    ../../modules/ssh.nix
    ../../modules/system.nix
    ../../modules/users.nix

    (import ../../modules/home.nix // home)
    (import ../../modules/networking.nix hostname)
    (import ../../modules/users.nix // password)

    ../../packages/common.nix
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
}
