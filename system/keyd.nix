{ pkgs, ... }:

{
  config = {
    systemd.services."keyd" = {
      enable = true;
      description = "Keyboard remapping daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        ExecStart = "${pkgs.keyd}/bin/keyd";
      };
    };

    environment.etc."keyd/default.conf".text = ''
      [ids]
      *

      [main]
      capslock = esc
      esc = capslock

      [alt]
      q = home 
      e = end
    '';
  };
}
