{ pkgs, ... }:

let
  inherit (import ../utils) keys;
  ssh_listen_addr = 23231;
  git_listen_addr = 9418;
  http_listen_addr = 23232;
  stats_listen_addr = 23233;
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
      SOFT_SERVE_NAME = "Runestore";

      SOFT_SERVE_SSH_LISTEN_ADDR = ":${toString ssh_listen_addr}";
      SOFT_SERVE_GIT_LISTEN_ADDR = ":${toString git_listen_addr}";
      SOFT_SERVE_HTTP_LISTEN_ADDR = ":${toString http_listen_addr}";
      SOFT_SERVE_STATS_LISTEN_ADDR = ":${toString stats_listen_addr}";

      SOFT_SERVE_DATA_PATH = "/srv/soft-serve";
      SOFT_SERVE_INITIAL_ADMIN_KEYS = keys.wardstone;
    };

  };

  networking.firewall.allowedTCPPorts = [
    ssh_listen_addr
    git_listen_addr
    http_listen_addr
    stats_listen_addr
  ];
}
