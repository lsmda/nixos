{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dive # tool for exploring docker images
    docker
  ];

  home.file.".docker/config.json".text = ''
    {
      "psFormat": "table {{.RunningFor}}\t{{.State}}\t{{.Image}}\t{{.ID}}\t{{.Names}}"
    }
  '';
}
