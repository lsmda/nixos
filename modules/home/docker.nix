{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dive # tool for exploring docker images
    docker
  ];

  home.file.".docker/config.json".text = builtins.toJSON {
    psFormat = "table {{.RunningFor}}\t{{.State}}\t{{printf \"%.50s\" .Image}}\t{{.ID}}\t{{.Names}}";
    imagesFormat = "table {{printf \"%.50s\" .Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}\t{{.Size}}";
  };
}
