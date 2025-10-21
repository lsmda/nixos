{ pkgs, ... }:

let
  extensions = with pkgs.vscode-extensions; [
    # adpyke.vscode-sql-formatter
    angular.ng-template
    bradlc.vscode-tailwindcss
    charliermarsh.ruff
    # cweijan.vscode-database-client2
    esbenp.prettier-vscode
    formulahendry.auto-rename-tag
    # monokai.theme-monokai-pro-vscode
    # mutantdino.resourcemonitor
    sainnhe.gruvbox-material
  ];

  userSettings = (
    {
      editor.bracketPairColorization.enabled = false;
      editor.cursorBlinking = "smooth";
      editor.cursorStyle = "block";
      editor.fontFamily = "'Berkeley Mono', 'Symbols Nerd Font'";
      editor.fontLigatures = true;
      editor.fontSize = 12;
      editor.fontWeight = 400;
      editor.formatOnSave = true;
      editor.guides.bracketPairs = "active";
      editor.hover.enabled = false;
      editor.lineHeight = 1.4;
      editor.linkedEditing = true;
      editor.minimap.enabled = false;
      editor.minimap.renderCharacters = false;
      editor.snippetSuggestions = "top";
      editor.suggest.insertMode = "replace";
      editor.tabSize = 2;
      editor.tokenColorCustomizations.comments.fontStyle = "";
    }
    // {
      terminal.integrated.commandsToSkipShell = [
        "workbench.action.toggleSidebarVisibility"
      ];
      terminal.integrated.cursorBlinking = true;
      terminal.integrated.cursorStyle = "block";
      terminal.integrated.fontFamily = "'Berkeley Mono', 'Symbols Nerd Font'";
      terminal.integrated.fontSize = 12;
      terminal.integrated.fontWeight = 400;
      terminal.integrated.lineHeight = 1.4;
    }
    // {
      workbench.activityBar.location = "bottom";
      workbench.editor.enablePreview = false;
      workbench.colorTheme = "Gruvbox Material Dark";
      workbench.iconTheme = "Monokai Classic Icons";
      workbench.settings.editor = "json";
      workbench.sideBar.location = "right";
      workbench.startupEditor = "none";
      workbench.tree.indent = 15;
    }
    // {
      accessibility.verbosity.inlineChat = false;
      accessibility.verbosity.panelChat = false;
      breadcrumbs.enabled = true;
      chat.agent.enabled = false;
      chat.commandCenter.enabled = false;
      chat.editor.fontSize = 11;
      debug.console.fontSize = 11;
      emmet.showSuggestionsAsSnippets = true;
      emmet.triggerExpansionOnTab = true;
      explorer.confirmDelete = false;
      explorer.confirmDragAndDrop = false;
      explorer.confirmPasteNative = false;
      extensions.autoCheckUpdates = false;
      extensions.ignoreRecommendations = true;
      files.autoSave = "afterDelay";
      files.autoSaveDelay = 500;
      git.autofetch = true;
      git.confirmSync = false;
      redhat.telemetry.enabled = false;
      security.workspace.trust.untrustedFiles = "open";
      "[typescript]" = {
        editor.defaultFormatter = "esbenp.prettier-vscode";
      };
      typescript.preferGoToSourceDefinition = true;
      typescript.preferences.preferTypeOnlyAutoImports = true;
      typescript.updateImportsOnFileMove.enabled = "always";
      update.mode = "none";
      update.showReleaseNotes = false;
      window.menuBarVisibility = "toggle";
      "window.zoomLevel" = 2;
    }
  );

  keybindings = [
    # Editor
    {
      key = "ctrl+g ctrl+d";
      command = "gitlens.diffWithRevisionFrom";
    }
    {
      key = "alt+m";
      command = "workbench.action.gotoLine";
    }
    {
      key = "shift+k";
      command = "editor.action.showDefinitionPreviewHover";
    }
    {
      key = "alt+left";
      command = "workbench.action.navigateBack";
    }
    {
      key = "alt+right";
      command = "workbench.action.navigateForward";
    }

    # Files Explorer
    {
      key = "ctrl+e";
      command = "workbench.action.toggleSidebarVisibility";
    }
    {
      key = "a";
      command = "explorer.newFile";
      when = "filesExplorerFocus && !inputFocus";
    }
    {
      key = "r";
      command = "renameFile";
      when = "filesExplorerFocus && !inputFocus";
    }
    {
      key = "y";
      command = "filesExplorer.copy";
      when = "filesExplorerFocus && !inputFocus";
    }
    {
      key = "p";
      command = "filesExplorer.paste";
      when = "filesExplorerFocus && !inputFocus";
    }
    {
      key = "x";
      command = "filesExplorer.cut";
      when = "filesExplorerFocus && !inputFocus";
    }
    {
      key = "d";
      command = "deleteFile";
      when = "filesExplorerFocus && !inputFocus";
    }
    {
      key = "ctrl+shift+e";
      command = "workbench.files.action.focusFilesExplorer";
    }
    {
      key = "ctrl+shift+s";
      command = "workbench.view.scm";
    }
    {
      key = "ctrl+shift+r";
      command = "workbench.view.remote";
    }

    # Terminal
    {
      key = "alt+w";
      command = "workbench.action.togglePanel";
    }
    {
      key = "alt+t";
      command = "workbench.action.terminal.focusNext";
      when = "terminalFocus";
    }
    {
      key = "shift+alt+t";
      command = "workbench.action.terminal.new";
      when = "terminalFocus";
    }
    {
      key = "alt+d";
      command = "workbench.action.terminal.kill";
      when = "terminalFocus";
    }
    {
      key = "alt+x";
      command = "workbench.action.toggleMaximizedPanel";
      when = "terminalFocus";
    }
    {
      key = "ctrl+shift+l";
      command = "workbench.action.increaseViewWidth";
      when = "editorTextFocus";
    }
    {
      key = "ctrl+shift+h";
      command = "workbench.action.decreaseViewWidth";
      when = "editorTextFocus";
    }
    {
      key = "ctrl+shift+j";
      command = "workbench.action.terminal.resizePaneDown";
      when = "terminalFocus";
    }
    {
      key = "ctrl+shift+k";
      command = "workbench.action.terminal.resizePaneUp";
      when = "terminalFocus";
    }

    # Misc
    {
      key = "alt+q";
      command = "cursorHome";
      when = "editorTextFocus";
    }
    {
      key = "alt+e";
      command = "cursorEnd";
      when = "editorTextFocus";
    }
    {
      key = "shift+alt+h";
      command = "workbench.action.previousEditor";
    }
    {
      key = "shift+alt+l";
      command = "workbench.action.nextEditor";
    }
    {
      key = "ctrl+k w";
      command = "workbench.action.closeEditorsInGroup";
    }
    {
      key = "ctrl+shift+alt+down";
      command = "-editor.action.copyLinesDownAction";
      when = "editorTextFocus && !editorReadonly";
    }
    {
      key = "shift+alt+up";
      command = "editor.action.copyLinesUpAction";
      when = "editorTextFocus && !editorReadonly";
    }
    {
      key = "shift+alt+down";
      command = "editor.action.copyLinesDownAction";
      when = "editorTextFocus && !editorReadonly";
    }
  ];
in

{
  config = {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;

      profiles.default = {
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        extensions = extensions;
        keybindings = keybindings;
        userSettings = userSettings;
      };
    };
  };
}
