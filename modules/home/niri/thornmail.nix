''
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
''
