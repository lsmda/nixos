{ config, pkgs, ... }:

let
  nvidiaPackages = with pkgs; [
    nvidia-vaapi-driver
    vdpauinfo
  ];
  nvidiaVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    VDPAU_DRIVER = "nvidia";
  };
in

{
  config = {
    home.packages =
      with pkgs;
      [
        ffmpeg-full

        # x264 and x265 encoders/decoders
        x264
        x265

        libva # Video Acceleration API
        libva-utils # VA-API utilities for testing
        intel-media-driver # Intel hardware video acceleration
        intel-vaapi-driver # Legacy Intel VA-API driver
        mesa # Mesa drivers for video acceleration
      ]
      ++ (if config.hardware.nvidia.enabled then nvidiaPackages else [ ]);

    home.sessionVariables = {
      FFMPEG_VAAPI = "1";
      FFMPEG_VDPAU = "1";
    }
    // (if config.hardware.nvidia.enabled then nvidiaVariables else { });
  };
}
