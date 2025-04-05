{
  kitty.enable = true;

  kitty.settings = {
    scrollback_lines = 1000;
    scrollback_pager_history_size = 300; # mb

    enable_audio_bell = false;

    remember_window_size = true;
    window_margin_width = 1;

    font_family = "JetBrainsMono Nerd Font";
    font_size = 11;

    adjust_column_width = "110%";

    tab_bar_style = "separator";
    tab_separator = " | ";
    active_tab_font_style = "normal";

    confirm_os_window_close = 0;
    sync_to_monitor = true;
    window_padding_width = 5;
  };

  kitty.extraConfig = ''
    tab_bar_edge top
    tab_title_max_length 20
    tab_bar_style separator
    tab_separator " | "
    tab_title_template "{title}"
    active_tab_font_style bold
    inactive_tab_font_style bold
    action_alias launch_tab launch --type=tab --cwd=current

    map shift+alt+enter launch_tab
    map shift+alt+h previous_tab
    map shift+alt+l next_tab
    map shift+alt+backspace close_tab
  '';
}
