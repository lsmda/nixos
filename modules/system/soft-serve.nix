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
      User = "soft-serve";
      Group = "soft-serve";
    };

    environment = {
      SOFT_SERVE_DATA_PATH = "/srv/soft-serve";
      SOFT_SERVE_INITIAL_ADMIN_KEYS = ''
        "${secrets."ed25519/wardstone".path}"
        "${secrets."ed25519/spellbook".path}"
        "${secrets."ed25519/thornmail".path}"
      '';
    };

  };

  networking.firewall.allowedTCPPorts = [
    23231
  ];
}
