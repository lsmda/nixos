''
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
''
