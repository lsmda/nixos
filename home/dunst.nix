{ ... }:

let
  color = import ../themes/metal;
in

{
  services.dunst = {
    enable = true;

    settings.global = {
      width = "(300, 900)";

      dmenu = "fuzzel --dmenu";

      corner_radius = 8;
      gap_size = 8;
      horizontal_padding = 5;
      padding = 8;

      frame_color = color.base0A;
      frame_width = 1;
      separator_color = "frame";

      background = color.base00;
      foreground = color.base05;

      alignment = "right";
      font = "JetBrainsMono Nerd Font 10";

      min_icon_size = 46;

      offset = "5";
      origin = "top-right";
    };

    settings.urgency_low = {
      frame_color = color.base0A;
      timeout = 5;
    };

    settings.urgency_normal = {
      frame_color = color.base09;
      timeout = 10;
    };

    settings.urgency_critical = {
      frame_color = color.base08;
      timeout = 15;
    };
  };
}
