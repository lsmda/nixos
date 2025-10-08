{ config, pkgs, ... }:

let
  fqdn = config.www.fqdn or "lsmda.pm";
in

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "ssh.${fqdn}" = {
        proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
      };
    };
  };
}
