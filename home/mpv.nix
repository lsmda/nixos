{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;

    package = (
      pkgs.mpv.override {
        scripts = [
          pkgs.mpvScripts.autoload
          pkgs.mpvScripts.memo
          pkgs.mpvScripts.modernx
          pkgs.mpvScripts.mpris
          pkgs.mpvScripts.thumbfast
        ];
      }
    );

    bindings = {
      h = "seek -10";
      l = "seek 10";
      LEFT = "seek -10";
      RIGHT = "seek 10";

      j = "add volume -2";
      k = "add volume 2";
      WHEEL_UP = "add volume -2";
      WHEEL_DOWN = "add volume 2";

      "." = "frame-step";
      "," = "frame-back-step";

      s = "screenshot";

      SPACE = "cycle pause";

      "ctrl+w" = "quit";
    };

    config = {
      # start in fullscreen mode by default.
      fs = "yes";

      # disable the on screen controller (osc).
      osc = "no";

      # uses gpu-accelerated video output by default.
      vo = "gpu";

      # enables best hw decoder; turn off for software decoding
      hwdec = "yes";

      # saves the seekbar position on exit
      save-position-on-quit = "yes";

      # hides the cursor automatically
      cursor-autohide = 50;

      # audio
      alang = "eng";
      volume = 100;
      volume-max = 100;

      # subtitle
      slang = "eng";
      sub-auto = "fuzzy";
      sub-font = "Noto Sans";
      sub-font-size = 42;

      # screenshots
      screenshot-format = "png";
      screenshot-high-bit-depth = "no";
      screenshot-tag-colorspace = "yes";
      screenshot-png-compression = 8;
      screenshot-directory = "~/Pictures/Screenshots/";
      screenshot-template = "mpv-20%ty-%tm-%td-%tHh%tMm%tSs";

      osd-bar = true;
      osd-font = "Noto Sans";
      osd-font-size = 24;
    };

    scriptOpts.thumbfast = {
      spawn_first = true;
      network = true;
      hwdec = true;
    };
  };
}
