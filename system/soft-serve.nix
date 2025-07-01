{ lib, pkgs, ... }:

let
  inherit (import ../utils { inherit lib; }) keys createUsersGroups;
  serviceUser = "soft-serve";

  SSH_LISTEN_ADDR = 23231;
  GIT_LISTEN_ADDR = 9418;
  HTTP_LISTEN_ADDR = 23232;
  STATS_LISTEN_ADDR = 23233;
in

{
  users.groups = createUsersGroups [ serviceUser ];

  users.users.${serviceUser} = {
    description = "Soft-serve Service User";
    isSystemUser = true;
    group = serviceUser;
  };

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
      User = serviceUser;
      Group = serviceUser;
    };

    environment = {
      SOFT_SERVE_NAME = "Runestore";

      SOFT_SERVE_SSH_LISTEN_ADDR = ":${toString SSH_LISTEN_ADDR}";
      SOFT_SERVE_GIT_LISTEN_ADDR = ":${toString GIT_LISTEN_ADDR}";
      SOFT_SERVE_HTTP_LISTEN_ADDR = ":${toString HTTP_LISTEN_ADDR}";
      SOFT_SERVE_STATS_LISTEN_ADDR = ":${toString STATS_LISTEN_ADDR}";

      SOFT_SERVE_DATA_PATH = "/srv/${serviceUser}";
      SOFT_SERVE_INITIAL_ADMIN_KEYS = keys.wardstone;
    };

  };

  networking.firewall.allowedTCPPorts = [
    SSH_LISTEN_ADDR
    GIT_LISTEN_ADDR
    HTTP_LISTEN_ADDR
    STATS_LISTEN_ADDR
  ];
}
