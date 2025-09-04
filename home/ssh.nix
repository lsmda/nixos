{ config, pkgs, ... }:

let
  fqdn = config.fqdn;
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
