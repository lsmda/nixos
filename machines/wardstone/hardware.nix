{
  lib,
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  config = {
    boot.initrd.availableKernelModules = [ "xhci_pci" ];

    # enable bbr module
    boot.kernelModules = [ "tcp_bbr" ];

    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = lib.mkDefault true;

    # network hardening and performance
    boot.kernel.sysctl = {
      # disable magic sysrq key
      "kernel.sysrq" = 0;
      # ignore icmp broadcasts to avoid participating in smurf attacks
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      # ignore bad icmp errors
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      # reverse-path filter for spoof protection
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      # syn flood protection
      "net.ipv4.tcp_syncookies" = 1;
      # do not accept icmp redirects (prevent mitm attacks)
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      # do not send icmp redirects (we are not a router)
      "net.ipv4.conf.all.send_redirects" = 0;
      # do not accept ip source route packets (we are not a router)
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      # protect against tcp time-wait assassination hazards
      "net.ipv4.tcp_rfc1337" = 1;
      # tcp fast open (tfo)
      "net.ipv4.tcp_fastopen" = 3;
      # bufferbloat mitigations
      # requires >= 4.9 & kernel module
      "net.ipv4.tcp_congestion_control" = "bbr";
      # requires >= 4.19
      "net.core.default_qdisc" = "cake";
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };

    fileSystems."/mnt/hyperx" = {
      device = "/dev/disk/by-label/HOME_NFS";
      fsType = "ext4";
      options = [
        "noatime"
        "nofail"
        "x-systemd.automount"
        "x-systemd.before=local-fs.target"
      ];
    };

    hardware.enableAllFirmware = true;
    hardware.graphics.enable = true; # hardware acceleration

    boot.kernelPackages = pkgs.linuxKernel.rpiPackages.linux_rpi4;

    nixpkgs.config.allowUnfree = true;
    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  };
}
