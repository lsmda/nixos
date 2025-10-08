{ pkgs, ... }:

{
  config = {
    programs.bat = {
      enable = true;
      config.theme = "base16";
    };

    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        color_theme = "everforest-dark-hard";
        rounded_corners = false;
        theme_background = false;
        update_ms = 500;
      };
    };

    programs.lazygit = {
      enable = true;
      settings = {
        gui.showListFooter = false;
        gui.showRandomTip = false;
        gui.showCommandLog = false;
        gui.showBottomLine = false;
        gui.nerdFontsVersion = 3;
        gui.border = "single";
        quitOnTopLevelReturn = true;
        keybinding = {
          universal = {
            quit = "<esc>";
          };
        };
      };
    };

    programs.ripgrep = {
      enable = true;
      arguments = [
        "--max-columns=150"
        "--max-columns-preview"

        # search hidden files / directories (e.g. dotfiles) by default
        "--hidden"

        # using glob patterns to include/exclude files or folders
        "--glob=!.git/*"

        "--colors=line:none"
        "--colors=line:style:bold"

        # because who cares about case!?
        "--smart-case"
      ];
    };

    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        scan_timeout = 50;
        format = "$all";
        character = {
          success_symbol = "[\\$](bold green)";
          error_symbol = "[\\$](bold red)";
        };
      };
    };

    programs.yazi = {
      enable = true;
      enableNushellIntegration = true;
      plugins = {
        full-border = pkgs.yaziPlugins.full-border;
      };
      initLua = ''
        require("full-border"):setup {
          -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
          type = ui.Border.PLAIN,
        }
      '';
      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = [ "<Esc>" ];
              run = "close";
              desc = "Close.";
            }
          ];
        };
      };
      settings = {
        mgr = {
          ratio = [
            0
            2
            4
          ];
          sort_by = "natural";
          sort_dir_first = true;
          linemode = "mtime";
          show_symlink = true;
          scrolloff = 100;
        };
      };
      theme = {
        mgr = {
          preview_hovered = {
            underline = false;
          };
        };
        status = {
          sep_left = {
            open = "";
            close = "";
          };
          sep_right = {
            open = "";
            close = "";
          };
        };
      };
    };

    programs.zoxide = {
      enable = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };
  };
}
