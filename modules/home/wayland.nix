{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fuzzel # application launcher
    swaybg # background
    swaylock # lock screen
    xwayland-satellite # x11 support
    xdg-desktop-portal-gnome # screen sharing
    xdg-utils
    networkmanagerapplet # network manager
    playerctl # media player controller
    swaynotificationcenter # notifications manager

    # screenshots
    grim
    slurp

    wdisplays
    waypipe
    wev
    wf-recorder
    wl-clipboard
    wl-mirror
    wlr-randr
    wtype
    tessen
    emoji-picker
  ];

  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "Xwayland outside your Wayland";
      BindsTo = "graphical-session.target";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      Requisite = "graphical-session.target";
    };
    Service = {
      Type = "notify";
      NotifyAccess = "all";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      StandardOutput = "journal";
    };
    Install.WantedBy = [ "niri.service" ];
  };

  home.file.".config/niri/config.kdl".text = ''
    spawn-at-startup "${pkgs.waybar}/bin/waybar"
    spawn-at-startup "${pkgs.swaybg}/bin/swaybg" "-m" "fill" "-i" "${../../assets/00.jpg}"

    input {
      keyboard {
        xkb {
          layout "pt"
        }
        repeat-delay 400
        repeat-rate 40
      }

      touchpad {
        tap
        dwt
        natural-scroll
        accel-profile "flat"
        accel-speed 0.2
        scroll-method "two-finger"
      }

      // mouse {
      //  natural-scroll
      //  accel-speed 0.4
      //  accel-profile "flat"
      // }

      disable-power-key-handling
      warp-mouse-to-focus
    }

    output "eDP-1" {
      scale 1.75
    }

    layout {
      gaps 10
      center-focused-column "always"

      preset-column-widths {
        proportion 0.5
        proportion 0.75
        proportion 1.0
      }

      preset-window-heights {
        proportion 0.5
        proportion 0.75
        proportion 1.0
      }

      default-column-width {
        proportion 1.0;
      }

      focus-ring {
        off
      }

      border {
        width 4
        inactive-color "#333"
        active-color "#ae97c9"
      }

      shadow {
        on
        softness 25
        spread 0
        offset x=0 y=0
        color "#111c"
      }

      struts {
        left -4
        right -4
        top -9
        bottom -4
      }
    }

    environment {
      DISPLAY ":0"
      QT_QPA_PLATFORM "wayland"
      _JAVA_AWT_WM_NONREPARENTING "1"
      EGL_PLATFORM "wayland"
      NIXOS_OZONE_WL "1"
      ELECTRON_OZONE_PLATFORM_HINT "auto"
    }

    cursor {
      xcursor-theme "phinger-cursors-dark"
      xcursor-size 24
    }

    prefer-no-csd
    screenshot-path "~/Pictures/Screenshot %Y-%m-%d %H-%M-%S.png"

    animations {
      slowdown 1.0

      workspace-switch {
        spring damping-ratio=0.9 stiffness=800 epsilon=0.0001
      }

      horizontal-view-movement {
        spring damping-ratio=0.9 stiffness=800 epsilon=0.0001
      }

      window-open {
        duration-ms 250
        curve "ease-out-cubic"
      }

      window-close {
        duration-ms 250
        curve "ease-out-cubic"
      }

      window-movement {
        spring damping-ratio=0.9 stiffness=800 epsilon=0.0001
      }

      window-resize {
        spring damping-ratio=0.9 stiffness=800 epsilon=0.0001
      }

      config-notification-open-close {
        spring damping-ratio=0.9 stiffness=800 epsilon=0.0001
      }

      screenshot-ui-open {
        duration-ms 200
        curve "ease-out-quad"
      }
    }

    window-rule {
      geometry-corner-radius 4
      clip-to-geometry true
    }

    binds {
      Mod+Shift+Space { show-hotkey-overlay; }

      Mod+Return { spawn "ghostty"; }
      Mod+D { spawn "fuzzel"; }
      Mod+Shift+D { spawn "emoji-picker"; }
      Mod+P { spawn "tessen"; }
      Mod+Alt+L { spawn "loginctl" "lock-session"; }
      Mod+Shift+A { spawn "fnottctl" "actions"; }
      Mod+Shift+S { spawn "fnottctl" "dismiss"; }

      XF86AudioRaiseVolume allow-when-locked=true { spawn "swayosd-client" "--output-volume=raise"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "swayosd-client" "--output-volume=lower"; }
      XF86AudioMute allow-when-locked=true { spawn "swayosd-client" "--output-volume=mute-toggle"; }
      Mod+XF86AudioRaiseVolume allow-when-locked=true { spawn "swayosd-client" "--input-volume=raise"; }
      Mod+XF86AudioLowerVolume allow-when-locked=true { spawn "swayosd-client" "--input-volume=lower"; }
      Mod+XF86AudioMute allow-when-locked=true { spawn "swayosd-client" "--input-volume=mute-toggle"; }
      XF86AudioMicMute allow-when-locked=true { spawn "swayosd-client" "--input-volume=mute-toggle"; }
      XF86MonBrightnessDown { spawn "swayosd-client" "--brightness=lower"; }
      XF86MonBrightnessUp { spawn "swayosd-client" "--brightness=raise"; }

      Mod+Q { close-window; }

      Mod+H { focus-column-left; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }
      Mod+L { focus-column-right; }

      Mod+Shift+H { move-column-left; }
      Mod+Shift+J { move-column-to-workspace-down; }
      Mod+Shift+K { move-column-to-workspace-up; }
      Mod+Shift+L { move-column-right; }

      Mod+Shift+Home { move-column-to-first; }
      Mod+Shift+End { move-column-to-last; }

      Mod+Alt+J { move-workspace-down; }
      Mod+Alt+K { move-workspace-up; }

      Mod+Ctrl+H { set-column-width "-5%"; }
      Mod+Ctrl+J { set-window-height "+5%"; }
      Mod+Ctrl+K { set-window-height "-5%"; }
      Mod+Ctrl+L { set-column-width "+5%"; }

      Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

      Mod+WheelScrollRight      { focus-column-right; }
      Mod+WheelScrollLeft       { focus-column-left; }
      Mod+Ctrl+WheelScrollRight { move-column-right; }
      Mod+Ctrl+WheelScrollLeft  { move-column-left; }

      Mod+Shift+WheelScrollDown      { focus-column-right; }
      Mod+Shift+WheelScrollUp        { focus-column-left; }
      Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
      Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }
      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }
      Mod+Shift+6 { move-column-to-workspace 6; }
      Mod+Shift+7 { move-column-to-workspace 7; }
      Mod+Shift+8 { move-column-to-workspace 8; }
      Mod+Shift+9 { move-column-to-workspace 9; }

      Mod+Tab { focus-workspace-previous; }

      Mod+Comma  { consume-window-into-column; }
      Mod+Period { expel-window-from-column; }

      Mod+R { switch-preset-column-width; }
      Mod+Shift+R { switch-preset-window-height; }

      Mod+Ctrl+F { expand-column-to-available-width; }

      Mod+C { center-column; }

      Mod+V       { toggle-window-floating; }
      Mod+Shift+V { switch-focus-between-floating-and-tiling; }

      Print { screenshot; }
      Ctrl+Print { screenshot-screen; }
      Alt+Print { screenshot-window; }

      Mod+Shift+E { spawn "wlogout"; }
      Ctrl+Alt+Delete { quit; }

      Mod+Shift+P { power-off-monitors; }
    }
  '';

  services.swayosd = {
    enable = true;
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
    ];
  };

  programs.waybar = {
    enable = true;
    settings.main = {
      layer = "top";
      output = "eDP-1";
      margin = "6 8.5 6 8.5";
      spacing = 6;

      modules-left = [
        "custom/swaync"
        "custom/spotify"
      ];

      "custom/swaync" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          none = "󰂜";
          notification = "<span foreground='red'><sup></sup></span>";
          none-cc-open = "󰂚";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };

      "custom/spotify" = {
        tooltip = false;
        exec-if = "pgrep spotify";
        exec = "playerctl -p spotify -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
        format = "  {}";
        return-type = "json";
        on-click = "playerctl -p spotify play-pause";
        on-scroll-up = "playerctl -p spotify next";
        on-scroll-down = "playerctl -p spotify previous";
      };

      modules-center = [
        "clock"
      ];

      clock = {
        tooltip = false;
        format = "{:%b %d // %H:%M}";
        interval = 60;
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };

      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "battery"
      ];

      tray = {
        icon-size = 15;
        spacing = 8;
      };

      pulseaudio = {
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{icon}  {volume}% {format_source}";
        format-bluetooth-muted = "󰝟 {icon} {format_source}";
        format-icons = {
          car = "󰄋";
          default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          hands-free = "󰗋";
          headphone = "󰋋";
          headset = "󰋎";
          phone = "󰏲";
          portable = "󰄜";
        };
        format-muted = "󰝟 {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        on-click = "pwvucontrol";
        scroll-step = 1;
      };

      "pulseaudio#mic" = {
        format = "{format_source}";
        format-source = "";
        format-source-muted = "󰍭";
        tooltip-format = "{volume}% {format_source}";
        on-click = "pavucontrol";
        on-scroll-up = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 1%+";
        on-scroll-down = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 1%-";
      };

      network = {
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        format-disconnected = "󰌙 Disconnected";
        format-ethernet = "󰈀 {ipaddr}/{cidr}";
        format-linked = "󰌚 {ifname} (No IP)";
        format-wifi = "  {essid}";
        tooltip-format = "󰌘 {ifname} via {gwaddr}";
      };

      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "<b>{capacity}% {icon} </b>";
        format-full = "<span color='#82A55F'><b>{capacity}% {icon}</b></span>";
        format-icons = [
          "󰁻"
          "󰁻"
          "󰁼"
          "󰁼"
          "󰁾"
          "󰁾"
          "󰂀"
          "󰂀"
          "󰂂"
          "󰂂"
          "󰁹"
        ];
        tooltip-format = "{timeTo} | {power} W";
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
      }

      window#waybar {
        transition-property: background-color;
        transition-duration: 0.5s;
        background: transparent;
      }

      #custom-swaync,
      #custom-spotify,
      #tray,
      #pulseaudio,
      #network,
      #battery,
      #clock {
        border-radius: 4px;
        background-color: rgba(0, 0, 0, 0.45);
        color: rgba(240, 240, 250, 1);
        padding: 0.5rem 0.85rem;
      }

      #custom-swaync {
        min-width: 1.6rem;
      }
    '';
  };

  home.file.".config/fuzzel/fuzzel.ini" = {
    text = ''
      dpi-aware=no
      width=14
      line-height=20
      font=JetBrainsMono Nerd Font Md:size=12
      fields=name,categories
      icons-enabled=no
      lines=5
      horizontal-pad=30
      vertical-pad=30
      inner-pad=15
      prompt="$ "

      [colors]
      text=bbbbbbcc
      background=000000cc
      selection=444444cc
      selection-text=bbbbbbcc
      input=bbbbbbcc
      match=ffffffcc
      selection-match=ffffffcc
      prompt=bbbbbbcc

      [border]
      radius=12

      [dmenu]
      exit-immediately-if-empty=yes
    '';
  };
}
