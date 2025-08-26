{ config, lib, ... }:

{
  options = {
    machine.username = lib.mkOption {
      type = lib.types.str;
      description = "Name of user account";
    };
    machine.hostname = lib.mkOption {
      type = lib.types.str;
      description = "Name of host machine";
    };
  };

  config = {
    nix = {
      # run garbage collection whenever there is less than 500mb free space left
      extraOptions = ''
        min-free = ${toString (500 * 1024 * 1024)}
      '';

      #garbage collection
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 3d";
        persistent = true;
      };

      # use pre-built cuda binaries on NVIDIA system
      settings = {
        download-buffer-size = 262144000; # 250 MB (250 * 1024 * 1024)
        experimental-features = [
          "nix-command"
          "pipe-operators"
        ];
        substituters = [ "https://cuda-maintainers.cachix.org" ];
        trusted-public-keys = [
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];
      };
    };
  };
}
