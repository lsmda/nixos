{ ... }:

{
  programs.btop.enable = true;

  programs.btop.settings = {
    vim_keys = true;
    color_theme = "everforest-dark-hard";
    rounded_corners = false;
    theme_background = false;
    update_ms = 500;
  };
}
