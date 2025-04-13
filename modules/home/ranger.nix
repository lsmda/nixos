{ pkgs, ... }:

{
  programs.ranger = {
    enable = true;

    settings = {
      column_ratios = "2,2,6";
      draw_borders = "both";
      scroll_offset = 10;
      unicode_ellipsis = true;
      viewmode = "miller";

      collapse_preview = false;
      preview_directories = true;
      preview_files = true;
      preview_images = true;
      preview_images_method = "kitty";

      vcs_aware = true;
      vcs_backend_git = "local";
    };

    extraPackages = with pkgs; [
      atool # Archive CLI helper
      ffmpeg
      ffmpegthumbnailer # Video thumbnailer
      highlight # Source code highlight
      jq # JSON processor
      mediainfo # technical info on media files
      mpv # media player
      p7zip
      rclone
    ];

    rifle = [
      {
        condition = "ext (md|markdown), has glow";
        command = "glow --pager \"$@\"";
      }
    ];
  };
}
