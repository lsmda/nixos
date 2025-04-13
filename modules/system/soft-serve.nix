{ config, pkgs, ... }:

let
  secrets = config.sops.secrets;
in

{
  systemd.services."soft-serve" = {
    enable = true;
    description = "Soft Serve git server";
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 1;
      ExecStart = "${pkgs.soft-serve}/bin/soft serve";
      ExecStartPre = "mkdir -p /srv/soft-serve";
      User = "soft-serve";
      Group = "soft-serve";
    };

    environment = {
      SOFT_SERVE_DATA_PATH = "/srv/soft-serve";
      SOFT_SERVE_INITIAL_ADMIN_KEYS = "${secrets."ed25519/wardstone".path}";
    };

    path = with pkgs; [
      coreutils
    ];
  };
}
