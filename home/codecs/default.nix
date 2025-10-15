{ config, pkgs, ... }:

let
  nvidiaPackages = with pkgs; [
    nvidia-vaapi-driver
    vdpauinfo
  ];
in

{
  config = {
    home.packages =
      with pkgs;
      [
        ffmpeg-full

        intel-vaapi-driver # Legacy Intel VA-API driver
        libva # Video Acceleration API
        mesa # Mesa drivers for video acceleration

        x264
        x265
      ]
      ++ (if config.hardware.nvidia.enabled then nvidiaPackages else [ ]);

    home.sessionVariables = {
      FFMPEG_VAAPI = "1";
      FFMPEG_VDPAU = "1";
    };
  };
}
