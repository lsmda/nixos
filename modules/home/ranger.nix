{ pkgs, ... }:

let
  inherit (pkgs) fetchFromGitHub;
in

{
  programs.ranger = {
    enable = true;

    settings = {
      viewmode = "miller";
      column_ratios = "2,2,4";
      draw_borders = "both";
      unicode_ellipsis = true;
      preview_images = true;
      preview_images_method = "kitty";
      preview_files = true;
      preview_directories = true;
      collapse_preview = true;
    };

    extraPackages = with pkgs; [
      atool
      ffmpeg
      ffmpegthumbnailer
      highlight
      jq
      mediainfo
      mpv
      p7zip
      rclone
      w3m
    ];

    plugins = [
      {
        name = "ranger-archives";
        src = fetchFromGitHub {
          owner = "maximtrp";
          repo = "ranger-archives";
          rev = "b4e136b24fdca7670e0c6105fb496e5df356ef25";
          sha256 = "sha256-QJu5G2AYtwcaE355yhiG4wxGFMQvmBWvaPQGLsi5x9Q=";
        };
      }
      {
        name = "devicons2";
        src = fetchFromGitHub {
          owner = "cdump";
          repo = "ranger-devicons2";
          rev = "f7877aa0dd8caa1d498d935f6f49e57a4fc591e2";
          sha256 = "sha256-OMMQW/mn8J8mki41TD/7/CWaDFgp/zT7B2hfTH/m0Ug=";
        };
      }
      {
        name = "ranger-fzf-filter";
        src = fetchFromGitHub {
          owner = "MuXiu1997";
          repo = "ranger-fzf-filter";
          rev = "bf16de2e4ace415b685ff7c58306d0c5146f9f43";
          sha256 = "sha256-4J0OLNeXPKvS7WvpgGWJPOeecXFG0QJ5/GbM3qogFTk=";
        };
      }
    ];
  };
}
