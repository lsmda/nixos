{ config, ... }:

let
  theme = config.machine.theme;
in

{
  imports = [
    ../../system/theme
  ];

  config = {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          dpi-aware = "no";
          width = 30;
          line-height = 40;
          font = "Berkeley Mono:size=14";
          fields = "name,categories";
          icons-enabled = "no";
          lines = 5;
          horizontal-pad = 30;
          vertical-pad = 30;
          inner-pad = 15;
          prompt = "";
        };
        colors = {
          border = "${theme.lavender}ff";
          background = "${theme.crust}ff";
          input = "${theme.text}ff";
          prompt = "${theme.text}ff";
          text = "${theme.text}ff";
          selection = "${theme.lavender}ff";
          selection-text = "${theme.crust}ff";
          match = "${theme.text}ff";
          selection-match = "${theme.base}ff";
        };
        border = {
          width = 6;
          radius = 0;
        };
        dmenu = {
          exit-immediately-if-empty = "yes";
        };
      };
    };
  };
}
