{ pkgs, ... }:

{
  systemd.services."keyd" = {
    enable = true;
    description = "Keyboard remapping daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Restart = "on-failure";
      ExecStart = "${pkgs.keyd}/bin/keyd";
    };
  };

  environment.etc."keyd/default.conf" = {
    enable = true;
    text = ''
      [ids]
      *

      [main]
      capslock = esc

      [alt]
      q = home
      e = end
    '';
  };
}
