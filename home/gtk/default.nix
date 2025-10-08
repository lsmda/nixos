{ pkgs, ... }:

{
  config = {
    gtk = {
      enable = true;
      iconTheme.name = "Tela-grey-dark";
      iconTheme.package = pkgs.tela-icon-theme;
      cursorTheme.name = "BreezeX-RosePineDawn-Linux";
      cursorTheme.package = pkgs.rose-pine-cursor;
    };
  };
}
