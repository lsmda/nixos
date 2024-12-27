{ config, ... }:

{
  kitty.enable = true;

  kitty.settings = {
    # scrollback
    scrollback_lines = 10000;
    scrollback_pager_history_size = 300; # mb

    # disable audio
    enable_audio_bell = false;

    remember_window_size = "yes";
    window_margin_width = 1;

    font_family = "JetBrainsMono Nerd Font";
    font_size = 11;

    adjust_column_width = "110%";

    tab_bar_style = "separator";
    tab_separator = " | ";
    active_tab_font_style = "normal";

    confirm_os_window_close = 0;
    sync_to_monitor = "yes";
    window_padding_width = 5;
  };

  kitty.extraConfig = ''
    foreground ${config.theme.colors.base05}
    background ${config.theme.colors.base00}

    color0 ${config.theme.colors.base03}
    color1 ${config.theme.colors.base08}
    color2 ${config.theme.colors.base0B}
    color3 ${config.theme.colors.base09}
    color4 ${config.theme.colors.base0D}
    color5 ${config.theme.colors.base0E}
    color6 ${config.theme.colors.base0C}
    color7 ${config.theme.colors.base06}
    color8 ${config.theme.colors.base04}
    color9 ${config.theme.colors.base08}

    color10 ${config.theme.colors.base0B}
    color11 ${config.theme.colors.base0A}
    color12 ${config.theme.colors.base0C}
    color13 ${config.theme.colors.base0E}
    color14 ${config.theme.colors.base0C}
    color15 ${config.theme.colors.base07}
    color16 ${config.theme.colors.base00}
    color17 ${config.theme.colors.base0F}
    color18 ${config.theme.colors.base0B}
    color19 ${config.theme.colors.base09}
    color20 ${config.theme.colors.base0D}
    color21 ${config.theme.colors.base0E}
    color22 ${config.theme.colors.base0C}
    color23 ${config.theme.colors.base06}

    tab_fade 1
    tab_bar_style fade
    cursor ${config.theme.colors.base07}
    cursor_text_color ${config.theme.colors.base00}
    selection_foreground ${config.theme.colors.base01}
    selection_background ${config.theme.colors.base0D}
    url_color ${config.theme.colors.base0C}
    active_border_color ${config.theme.colors.base04}
    inactive_border_color ${config.theme.colors.base00}
    bell_border_color ${config.theme.colors.base03}
    active_tab_foreground ${config.theme.colors.base04}
    active_tab_background ${config.theme.colors.base00}
    active_tab_font_style bold
    inactive_tab_foreground ${config.theme.colors.base07}
    inactive_tab_background ${config.theme.colors.base08}
    inactive_tab_font_style bold
    tab_bar_background ${config.theme.colors.base00}
  '';
}
