{
  config = {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          dpi-aware = "no";
          width = 20;
          line-height = 40;
          font = "Berkeley Mono:size=14";
          fields = "name,categories";
          icons-enabled = "no";
          lines = 5;
          horizontal-pad = 30;
          vertical-pad = 30;
          inner-pad = 15;
          prompt = "$ ";
        };
        colors = {
          border = "ffffffff";
          text = "bbbbbbcc";
          background = "000000cc";
          selection = "444444cc";
          selection-text = "bbbbbbcc";
          input = "bbbbbbcc";
          match = "ffffffcc";
          selection-match = "ffffffcc";
          prompt = "bbbbbbcc";
        };
        border = {
          radius = 0;
        };
        dmenu = {
          exit-immediately-if-empty = "yes";
        };
      };
    };
  };
}
