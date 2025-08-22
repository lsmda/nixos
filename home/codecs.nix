{ config, pkgs, ... }:

let
  nvidia = with pkgs; [
    # NVIDIA-specific packages (if using NVIDIA GPU)
    nvidia-vaapi-driver # NVIDIA VA-API driver
    vdpauinfo # VDPAU info utility
  ];
in

{
  # Install comprehensive media codec support including H.265/HEVC
  home.packages =
    with pkgs;
    [
      # FFmpeg with full codec support
      ffmpeg-full

      # x264 and x265 encoders/decoders
      x264
      x265

      # Additional media libraries
      libva # Video Acceleration API
      libva-utils # VA-API utilities for testing
      intel-media-driver # Intel hardware video acceleration
      intel-vaapi-driver # Legacy Intel VA-API driver
      mesa # Mesa drivers for video acceleration

      # Media players with codec support
      vlc # VLC media player with extensive codec support
    ]
    ++ (if config.hardware.nvidia.enabled then nvidia else [ ]);

  # Set environment variables for hardware acceleration
  home.sessionVariables =
    {
      # FFmpeg hardware acceleration
      FFMPEG_VAAPI = "1";
      FFMPEG_VDPAU = "1";
    }
    // (
      if config.hardware.nvidia.enabled then
        {
          # Enable NVIDIA hardware video acceleration
          LIBVA_DRIVER_NAME = "nvidia";
          VDPAU_DRIVER = "nvidia";
        }
      else
        { }
    );
}
