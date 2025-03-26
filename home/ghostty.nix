{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ghostty
  ];

  home.file.".config/ghostty/config".text = ''
    font-family = "JetBrainsMono Nerd Font"
    font-size = 11
    adjust-cell-width = 10%
    adjust-cell-height = 5%

    window-padding-x = 4
    window-padding-y = 8
    window-inherit-working-directory = true

    clipboard-trim-trailing-spaces = true
    clipboard-paste-protection = true

    quick-terminal-position = center

    cursor-style = block
    cursor-style-blink = false
    cursor-invert-fg-bg = true

    shell-integration-features = no-cursor

    mouse-hide-while-typing = true
    background-opacity = 0.98
    background-blur = true

    scrollback-limit = 9999999

    keybind = shift+alt+enter=new_tab
    keybind = shift+alt+backspace=close_tab
    keybind = shift+alt+h=previous_tab
    keybind = shift+alt+l=next_tab
    keybind = ctrl+shift+r=reload_config

    theme = Everforest Dark - Hard

    font-feature = ss01
    font-feature = ss04

    adjust-box-thickness = 1
    adjust-cursor-thickness = 1
     
    resize-overlay = never
    copy-on-select = false
    confirm-close-surface = false

    window-padding-balance = true
    window-padding-color = background
    gtk-single-instance = false

    auto-update = off
    term = ghostty
  '';
}
