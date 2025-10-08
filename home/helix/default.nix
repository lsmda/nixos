{ pkgs, ... }:

{
  imports = [
    ./keys.nix
    ./languages.nix
  ];

  config = {
    home.packages = with pkgs; [
      scooter
    ];
    programs.helix = {
      enable = true;
      defaultEditor = true;

      extraPackages = with pkgs; [
        # html, css
        vscode-langservers-extracted

        # javascript
        deno
        nodePackages.prettier
        nodePackages.typescript-language-server
        prettierd
        vscode-langservers-extracted

        kdlfmt

        # nix
        nil
        nixd
        nixfmt-rfc-style

        # python
        pyright
        ruff
      ];

      settings.theme = "base16_transparent";

      settings.editor = {
        popup-border = "all";
        line-number = "relative";
        mouse = false;
        continue-comments = false;
        true-color = true;
        default-yank-register = "+";
        default-line-ending = "lf";
        scrolloff = 50;
        color-modes = true;
        soft-wrap.enable = false;

        text-width = 120;
        completion-replace = true;
        completion-timeout = 250;
        completion-trigger-len = 2;

        jump-label-alphabet = "hjklabcdefgimnopqrstuvwxyz";

        file-picker = {
          hidden = false;
        };

        indent-guides = {
          render = true;
          character = "┊";
          skip-levels = 2;
        };

        lsp = {
          enable = true;
          display-messages = true;
        };

        statusline = {
          left = [
            "mode"
            "file-name"
            "version-control"
            "file-modification-indicator"
          ];
          right = [
            "spinner"
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
          mode = {
            normal = "N";
            insert = "I";
            select = "S";
          };
        };
      };
    };
  };
}
