{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dive # tool for exploring docker images
    docker
  ];

  home.file.".docker/config.json".text = ''
    { "psFormat": "table {{.RunningFor}}\t{{.State}}\t{{printf \"%.50s\" .Image}}\t{{.ID}}\t{{.Names}}" }
  '';
}
