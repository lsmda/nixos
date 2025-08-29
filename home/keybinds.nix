{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      flameshot
    ];

    dconf.settings = {
      # disable default keybinds
      "org/gnome/shell/keybindings" = {
        screenshot = [ ];
        show-screenshot-ui = [ ];
      };

      # define custom keybinds
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "Print";
        command = "flameshot gui --clipboard --path /home/user/Pictures/Screenshots/";
        name = "show-flameshot-ui";
      };

      # enable custom keybinds
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
    };
  };
}
