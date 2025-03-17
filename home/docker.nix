{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dive # tool for exploring docker images
    docker
  ];

  home.file.".docker/config.json".text = ''
    {
      "psFormat": "table {{.ID}}\\t{{.Names}}\\t{{.Status}}\\t{{.CreatedAt}}"
    }
  '';
}
