{
  config = {
    programs.fastfetch.enable = true;

    programs.fastfetch.settings.logo.source = "Sparky";
    programs.fastfetch.settings.logo.color."1" = "36";
    programs.fastfetch.settings.logo.padding.top = 1;
    programs.fastfetch.settings.logo.padding.right = 2;
    programs.fastfetch.settings.logo.padding.left = 4;

    programs.fastfetch.settings.display.separator = "  ";

    programs.fastfetch.settings.modules = [
      "break"
      {
        type = "title";
        key = "  ";
        color = {
          user = "36";
          at = "38";
          host = "36";
        };
      }
      "break"
      {
        type = "os";
        key = "  ";
      }
      {
        type = "kernel";
        key = "  ";
      }
      "break"
      {
        type = "host";
        format = "{5} {1} Type {2}";
        key = "  ";
      }
      {
        type = "cpu";
        format = "{1} ({3}) @ {7} GHz";
        key = "  ";
      }
      {
        type = "gpu";
        format = "{1} {2}";
        key = "  ";
      }
      {
        type = "memory";
        key = "  ";
      }
      {
        type = "disk";
        key = "  ";
      }
      {
        type = "monitor";
        key = "  ";
      }
      "break"
      {
        type = "localip";
        key = "  ";
      }
      "break"
      {
        type = "colors";
        key = "  ";
        symbol = "circle";
      }
    ];
  };
}
