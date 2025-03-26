{ lib, pkgs, ... }:

{
  programs.helix.enable = true;

  programs.helix.languages.language-server = {
    nil.command = "${lib.getExe pkgs.nil}";
    typescript-language-server.command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
    vscode-css-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
    vscode-eslint-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server";
    vscode-html-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
  };

  programs.helix.languages.language = [
    {
      name = "typescript";
      language-servers = [ "typescript-language-server" ];
      formatter.command = "prettier";
      formatter.args = [
        "--parser"
        "typescript"
      ];
      formatter.binary = "${lib.getExe pkgs.nodePackages.prettier}";
    }
    {
      name = "nix";
      language-servers = [ "nil" ];
      formatter.binary = "${lib.getExe pkgs.nixfmt-rfc-style}";
      formatter.command = "nixfmt";
    }
  ];

  programs.helix.extraPackages = with pkgs; [
    dockerfile-language-server-nodejs # Dockerfile
    vscode-langservers-extracted # HTML/CSS/JSON

    # Python
    python312Packages.python-lsp-server
    ruff

    # Markdown
    markdown-oxide
    marksman

    # TS/JS
    nodePackages.typescript-language-server
    nodePackages.prettier

    # Nix
    nixfmt-rfc-style
    nil
  ];

  home.file.".config/helix/config.toml".text = ''
    theme = "main"

    [editor]
    text-width = 90
    true-color = true
    line-number = "relative"
    auto-format = true
    mouse = false
    color-modes = true
    [editor.indent-guides]
    render = true
    [editor.file-picker]
    hidden = false
    [editor.lsp]
    enable = true
    display-messages = true
    [editor.statusline]
    left = [ "mode", "file-name", "version-control", "file-modification-indicator" ]
    right = [ "spinner", "diagnostics", "selections", "position", "file-encoding", "file-line-ending", "file-type" ]

    [keys.normal]
    "C-a" = "select_all"
    "A-h" = "jump_backward"
    "A-l" = "jump_forward"

    "C-h" = "jump_view_left"
    "C-j" = "jump_view_down"
    "C-k" = "jump_view_up"
    "C-l" = "jump_view_right"

    "A-e" = "goto_line_end"
    "A-q" = "goto_line_start"

    "C-space" = "expand_selection"
    "backspace" = "shrink_selection"

    "ret" = ["open_below", "normal_mode"]

    "A-j" = ["extend_to_line_bounds", "delete_selection", "move_line_down", "paste_before", "collapse_selection"]
    "A-k" = ["extend_to_line_bounds", "delete_selection", "move_line_up", "paste_before", "collapse_selection"]

    "A-S-j" = ["extend_to_line_bounds", "yank", "paste_after"]
    "A-S-k" = ["extend_to_line_bounds", "yank", "paste_before"]

    [keys.normal."space"]
    w = [":fmt" , ":write"]
    q = ":quit"
    Q = ":quit-all!"
    p = "paste_clipboard_before"

    [keys.normal."space".s]
    j = ":hsplit"
    l = ":vsplit"

    [keys.normal."space".r]
    r = ":config-reload"

    [keys.insert]
    "A-n" = "normal_mode"
    "C-h" = "move_char_left"
    "C-l" = "move_char_right"
    "C-k" = "move_line_up"
    "C-j" = "move_line_down"

    [keys.select]
    "A-n" = "normal_mode"
    "A-e" = "extend_to_line_end"
    "A-q" = "extend_to_line_start"
    "A-k" = ["delete_selection", "move_visual_line_up", "paste_before"]
    "A-j" = ["delete_selection", "move_visual_line_down", "paste_before"]
  '';

  home.file.".config/helix/themes/main.toml".text = ''
    inherits = "amberwood"
    "ui.background" = {}
    "ui.menu" = {}
    "ui.popup" = {}
    "ui.statusline" = {}
    "ui.window" = {}
  '';
}
