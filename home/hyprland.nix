{
  config,
  lib,
  pkgs,
  ...
}:

let
  color = import ../themes/metal;
  theme = import ../modules/theme.nix;
  slice_hex = builtins.substring 1 6;

  workspace_range = lib.range 1 4;
  workspace_bindings = map (n: [
    "SUPER, ${toString n}, workspace, ${toString n}"
    "SUPER+SHIFT, ${toString n}, movetoworkspacesilent, ${toString n}"
  ]) workspace_range;
in

{
  wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];
  wayland.windowManager.hyprland.systemd.enableXdgAutostart = true;

  wayland.windowManager.hyprland.settings = {
    monitor = [ ", preferred, auto, 1.5" ];

    windowrulev2 = [
      "opacity 0.94 0.94, class:.*"
      "workspace special silent, initialclass:^(xwaylandvideobridge)$"
    ];

    exec-once = [
      "${pkgs.waybar}/bin/waybar"
      "${pkgs.swaybg}/bin/swaybg -i ${../assets/00.jpg}"
    ];

    bind = [
      "SUPER, RETURN, exec, ${lib.getExe pkgs.kitty}"
      "SUPER, B, exec, ${lib.getExe config.programs.chromium.package}"

      "ALT, R, exec, rofi -show combi -combi-modes 'run,drun' -modes combi"

      "SUPER, TAB, workspace, e+1"
      "SUPER+SHIFT, TAB, workspace, e-1"
      "SUPER, mouse_up, workspace, e+1"
      "SUPER, mouse_down, workspace, e+1"

      "SUPER, h, movewindow, l"
      "SUPER, l, movewindow, r"
      "SUPER, j, movewindow, d"
      "SUPER, k, movewindow, u"

      "SUPER, Q, killactive"
      "SUPER, SPACE, fullscreen, 1"
    ] ++ lib.flatten workspace_bindings;

    bindle = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.5"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

      ", XF86MonBrightnessUp  , exec, brightnessctl set 5%+"
      ", XF86MonBrightnessDown, exec, brightnessctl set --min-value=1 5%-"
    ];

    bindl = [
      ", XF86AudioMute   , exec, wpctl set-mute @DEFAULT_AUDIO_SINK@   toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];

    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:274, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];

    binde = [
      "SHIFT, h, movefocus, l"
      "SHIFT, l, movefocus, r"
      "SHIFT, j, movefocus, d"
      "SHIFT, k, movefocus, u"

      "SUPER+CTRL, h, resizeactive, -100 0"
      "SUPER+CTRL, j, resizeactive, 0 100"
      "SUPER+CTRL, k, resizeactive, 0 -100"
      "SUPER+CTRL, l, resizeactive, 100 0"
    ];

    general = {
      gaps_in = 8;
      gaps_out = 8;
      border_size = theme.border;

      "col.active_border" = "0xff${slice_hex color.base05}";
      "col.nogroup_border_active" = "0xff${slice_hex color.base05}";
    };

    animations = {
      bezier = [ "material_decelerate, 0.05, 0.7, 0.1, 1" ];

      animation = [
        "border    , 1, 2, material_decelerate"
        "fade      , 1, 2, material_decelerate"
        "layers    , 1, 2, material_decelerate"
        "windows   , 1, 2, material_decelerate, popin 80%"
        "workspaces, 1, 2, material_decelerate"
      ];
    };

    misc = {
      animate_manual_resizes = true;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      key_press_enables_dpms = true;
      mouse_move_enables_dpms = true;
    };

    input = {
      touchpad.clickfinger_behavior = true;
      touchpad.drag_lock = true;
      touchpad.natural_scroll = true;
      touchpad.scroll_factor = 0.65;
    };

    decoration = {
      rounding = theme.radius;

      blur = {
        enabled = true;
        size = 8;
        passes = 1;
        ignore_opacity = true;
      };
    };

    layerrule = [
      "blur, rofi"
      "blur, waybar"
    ];

    gestures.workspace_swipe = true;

    cursor.hide_on_key_press = true;
    cursor.inactive_timeout = 10;
  };

  home.packages = with pkgs; [
    brightnessctl # control screen brightness
    swaybg # wallpaper manager
    wl-clipboard # clipboard manager for wayland
    xdg-utils # desktop integration tools
    xwaylandvideobridge # screen sharing for xwayland apps
  ];
}
