{ pkgs, ... }:

{
  config = {
    programs.mpv = {
      enable = true;

      package = (
        pkgs.mpv.override {
          scripts = [
            pkgs.mpvScripts.autoload
            pkgs.mpvScripts.memo
            pkgs.mpvScripts.modernz
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
        # disable the on screen controller (osc).
        osc = "no";

        profile = "gpu-hq";
        # uses gpu-accelerated video output by default.
        vo = "gpu";
        gpu-api = "vulkan";

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

    home.file.".config/mpv/script-opts/modernz.conf".text = ''
      # Language and display
      # set language (for available options, see: https://github.com/Samillion/ModernZ/blob/main/docs/TRANSLATIONS.md)
      language=en
      # set icon theme. accepts fluent or material
      icon_theme=material
      # font for the OSC (default: mpv-osd-symbols or the one set in mpv.conf)
      font=mpv-osd-symbols

      ontop_button=yes
      loop_button=yes
      info_button=yes
      fullscreen_button=yes

      # Colors and style
      # accent color of the OSC and title bar
      seekbarfg_color=#ffffff
    '';
  };
}
