{ pkgs, ... }:

{
  gtk.enable = true;

  gtk.iconTheme.name = "Tela-grey-dark";
  gtk.iconTheme.package = pkgs.tela-icon-theme;

  gtk.cursorTheme.name = "BreezeX-RosePineDawn-Linux";
  gtk.cursorTheme.package = pkgs.rose-pine-cursor;
}
