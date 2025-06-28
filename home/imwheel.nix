{ pkgs, ... }:

{
  home.packages = with pkgs; [
    imwheel
  ];

  home.file.".imwheelrc".text = ''
    ".*"
    None,      Up,   Button4, 3
    None,      Down, Button5, 3
    Control_L, Up,   Control_L|Button4
    Control_L, Down, Control_L|Button5
    Shift_L,   Up,   Shift_L|Button4
    Shift_L,   Down, Shift_L|Button5
    None, Thumb1  , Alt_L|Left
    None, Thumb2  , Alt_L|Right
  '';

  home.file.".config/autostart/imwheel.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=IMWheel
    Exec=imwheel
    X-GNOME-Autostart-enabled=true
  '';
}
