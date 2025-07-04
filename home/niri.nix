{
  config,
  lib,
  pkgs,
  ...
}:

let
  common = ''
    spawn-at-startup "${pkgs.waybar}/bin/waybar"

    prefer-no-csd
    screenshot-path "~/Pictures/Screenshot %Y-%m-%d %H-%M-%S.png"

    hotkey-overlay {
      skip-at-startup
    }

    cursor {
      xcursor-theme "BreezeX-RosePineDawn-Linux"
      xcursor-size 32
    }

    environment {
      DISPLAY ":0"
      QT_QPA_PLATFORM "wayland"
      _JAVA_AWT_WM_NONREPARENTING "1"
      EGL_PLATFORM "wayland"
      NIXOS_OZONE_WL "1"
      ELECTRON_OZONE_PLATFORM_HINT "auto"
    }

    layout {
      gaps 10

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
      Mod+Tab { toggle-overview; }

      Mod+D { spawn "fuzzel"; }
      Mod+P { spawn "tessen"; }
      Mod+Q { close-window; }

      Mod+Return { spawn "ghostty"; }
      Mod+Shift+D { spawn "emoji-picker"; }

      XF86AudioRaiseVolume allow-when-locked=true { spawn "swayosd-client" "--output-volume=raise"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "swayosd-client" "--output-volume=lower"; }
      XF86AudioMute allow-when-locked=true { spawn "swayosd-client" "--output-volume=mute-toggle"; }
      Mod+XF86AudioRaiseVolume allow-when-locked=true { spawn "swayosd-client" "--input-volume=raise"; }
      Mod+XF86AudioLowerVolume allow-when-locked=true { spawn "swayosd-client" "--input-volume=lower"; }
      Mod+XF86AudioMute allow-when-locked=true { spawn "swayosd-client" "--input-volume=mute-toggle"; }
      XF86AudioMicMute allow-when-locked=true { spawn "swayosd-client" "--input-volume=mute-toggle"; }
      XF86MonBrightnessDown { spawn "swayosd-client" "--brightness=lower"; }
      XF86MonBrightnessUp { spawn "swayosd-client" "--brightness=raise"; }

      Mod+H { focus-column-left; }
      Mod+J { focus-workspace-down; }
      Mod+K { focus-workspace-up; }
      Mod+L { focus-column-right; }

      Mod+Shift+H { move-column-left; }
      Mod+Shift+J { move-column-to-workspace-down; }
      Mod+Shift+K { move-column-to-workspace-up; }
      Mod+Shift+L { move-column-right; }

      Mod+Alt+J { move-workspace-down; }
      Mod+Alt+K { move-workspace-up; }

      Mod+Ctrl+H { set-column-width "-10%"; }
      Mod+Ctrl+J { set-window-height "+10%"; }
      Mod+Ctrl+K { set-window-height "-10%"; }
      Mod+Ctrl+L { set-column-width "+10%"; }

      Mod+WheelScrollDown        { focus-workspace-down; }
      Mod+WheelScrollUp          { focus-workspace-up; }
      Mod+Shift+WheelScrollDown  { focus-column-right; }
      Mod+Shift+WheelScrollUp    { focus-column-left; }

      Mod+Comma  { consume-window-into-column; }
      Mod+Period { expel-window-from-column; }

      Mod+R { switch-preset-column-width; }
      Mod+Shift+R { switch-preset-window-height; }

      Print { screenshot; }
      Ctrl+Print { screenshot-screen; }
      Alt+Print { screenshot-window; }

      Mod+Escape { spawn "wlogout" "-b" "4"; }
      Ctrl+Alt+Delete { quit; }
    }
  '';

  custom = {
    spellbook = ''
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
          accel-profile "adaptive"
          accel-speed -0.1
          scroll-method "two-finger"
        }

        disable-power-key-handling
        warp-mouse-to-focus
      }

      output "eDP-1" {
        scale 1.5
      }
    '';
    thornmail = ''
      input {
        keyboard {
          xkb {
            layout "us"
          }
          repeat-delay 400
          repeat-rate 40
        }

        mouse {
          accel-profile "adaptive"
          accel-speed -0.1
        }

        disable-power-key-handling
        warp-mouse-to-focus
      }

      output "DP-3" {
        mode "1920x1080@60.000"
      }
    '';
  };
in

{
  home.file.".config/niri/config.kdl".text = lib.strings.concatStringsSep "\n\n" [
    common
    custom.${config.machine.hostname}
  ];
}
