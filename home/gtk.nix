{ pkgs, ... }:

{
  gtk.enable = true;

  gtk.iconTheme.name = "Tela-grey-dark";
  gtk.iconTheme.package = pkgs.tela-icon-theme;
}
