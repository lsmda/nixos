{ ... }:

let
  color = import ../themes/metal;
in

{
  services.dunst = {
    enable = true;

    settings = {
      global = {
        monitor = 0;
        follow = "none";
        width = 300;
        height = 145;
        origin = "top-right";
        alignment = "left";
        vertical_alignment = "center";
        ellipsize = "end";
        offset = "15x15";
        padding = 15;
        horizontal_padding = 15;
        text_icon_padding = 15;
        icon_position = "left";
        min_icon_size = 48;
        max_icon_size = 64;
        progress_bar = true;
        progress_bar_height = 6;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        separator_height = 2;
        frame_width = 3;
        frame_color = color.base05;
        separator_color = "frame";
        corner_radius = 8;
        transparency = "0.1";
        gap_size = 8;
        line_height = 4;
        notification_limit = 0;
        idle_threshold = 120;
        history_length = 20;
        show_age_threshold = 60;
        markup = "full";
        font = "sans 10";
        format = "<b>%s</b>\n%b";
        word_wrap = "no";
        sort = "yes";
        shrink = "yes";
        indicate_hidden = "yes";
        sticky_history = "yes";
        ignore_newline = "no";
        show_indicators = "no";
        stack_duplicates = true;
        always_run_script = true;
        hide_duplicate_count = false;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
      };

      experimental = {
        per_monitor_dpi = false;
      };

      urgency_low = {
        background = color.base00;
        foreground = color.base05;
        highlight = color.base0A;
        timeout = 4;
      };

      urgency_normal = {
        background = color.base00;
        foreground = color.base05;
        highlight = color.base0A;
        timeout = 6;
      };

      urgency_critical = {
        background = color.base00;
        foreground = color.base05;
        highlight = color.base0A;
        timeout = 0;
      };
    };
  };
}
