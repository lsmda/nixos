{ ... }:

{
  programs.lazygit.enable = true;
  programs.lazygit.settings = {
    gui.showListFooter = false;
    gui.showRandomTip = false;
    gui.showCommandLog = false;
    gui.showBottomLine = false;
    gui.nerdFontsVersion = 3;
    gui.border = "single";
  };
}
