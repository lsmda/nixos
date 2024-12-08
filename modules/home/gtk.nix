{ pkgs, ... }:

{
  gtk = {
    enable = true;

    iconTheme = {
      name = "Tela-grey-dark";
      package = pkgs.tela-icon-theme;
    };

    cursorTheme = {
      name = "BreezeX-RosePineDawn-Linux";
      package = pkgs.rose-pine-cursor;
    };
  };
}
