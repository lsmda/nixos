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
    foreground ${config.colorscheme.base05}
    background ${config.colorscheme.base00}

    color0 ${config.colorscheme.base03}
    color1 ${config.colorscheme.base08}
    color2 ${config.colorscheme.base0B}
    color3 ${config.colorscheme.base09}
    color4 ${config.colorscheme.base0D}
    color5 ${config.colorscheme.base0E}
    color6 ${config.colorscheme.base0C}
    color7 ${config.colorscheme.base06}
    color8 ${config.colorscheme.base04}
    color9 ${config.colorscheme.base08}

    color10 ${config.colorscheme.base0B}
    color11 ${config.colorscheme.base0A}
    color12 ${config.colorscheme.base0C}
    color13 ${config.colorscheme.base0E}
    color14 ${config.colorscheme.base0C}
    color15 ${config.colorscheme.base07}
    color16 ${config.colorscheme.base00}
    color17 ${config.colorscheme.base0F}
    color18 ${config.colorscheme.base0B}
    color19 ${config.colorscheme.base09}
    color20 ${config.colorscheme.base0D}
    color21 ${config.colorscheme.base0E}
    color22 ${config.colorscheme.base0C}
    color23 ${config.colorscheme.base06}

    tab_fade 1
    tab_bar_style fade
    cursor ${config.colorscheme.base07}
    cursor_text_color ${config.colorscheme.base00}
    selection_foreground ${config.colorscheme.base01}
    selection_background ${config.colorscheme.base0D}
    url_color ${config.colorscheme.base0C}
    active_border_color ${config.colorscheme.base04}
    inactive_border_color ${config.colorscheme.base00}
    bell_border_color ${config.colorscheme.base03}
    active_tab_foreground ${config.colorscheme.base04}
    active_tab_background ${config.colorscheme.base00}
    active_tab_font_style bold
    inactive_tab_foreground ${config.colorscheme.base07}
    inactive_tab_background ${config.colorscheme.base08}
    inactive_tab_font_style bold
    tab_bar_background ${config.colorscheme.base00}
  '';
}
