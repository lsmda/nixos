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

  keybindings = [
    # Editor
    {
      key = "ctrl+g ctrl+d";
      command = "gitlens.diffWithRevisionFrom";
    }
    {
      key = "ctrl+k k";
      command = "editor.action.showHover";
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
      key = "w";
      command = "list.selectAndPreserveFocus";
      when = "sideBarFocus && !inputFocus";
    }
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
      key = "shift+a";
      command = "explorer.newFolder";
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
    }

    # Removed
    {
      key = "ctrl+shift+t";
      command = "-workbench.action.reopenClosedEditor";
    }
    {
      key = "ctrl+g";
      command = "-workbench.action.gotoLine";
    }
    {
      key = "ctrl+k e";
      command = "-workbench.files.action.focusOpenEditorsView";
      when = "workbench.explorer.openEditorsView.active";
    }
    {
      key = "ctrl+e";
      command = "-workbench.action.quickOpen";
    }
    {
      key = "ctrl+e ctrl+q";
      command = "-sqltools.bookmarkSelection";
      when = "editorHasSelection && editorTextFocus && !config.sqltools.disableChordKeybindings";
    }
    {
      key = "ctrl+e ctrl+r";
      command = "-sqltools.deleteBookmark";
      when = "!config.sqltools.disableChordKeybindings";
    }
    {
      key = "ctrl+e ctrl+a";
      command = "-sqltools.runFromBookmarks";
      when = "!config.sqltools.disableChordKeybindings";
    }
    {
      key = "ctrl+e ctrl+d";
      command = "-sqltools.describeTable";
      when = "!config.sqltools.disableChordKeybindings";
    }
    {
      key = "ctrl+e ctrl+e";
      command = "-sqltools.executeQuery";
      when = "editorHasSelection && editorTextFocus && !config.sqltools.disableChordKeybindings";
    }
    {
      key = "ctrl+e ctrl+s";
      command = "-sqltools.showRecords";
      when = "!config.sqltools.disableChordKeybindings";
    }
    {
      key = "ctrl+e ctrl+h";
      command = "-sqltools.runFromHistory";
      when = "!config.sqltools.disableChordKeybindings";
    }
    {
      key = "ctrl+e ctrl+b";
      command = "-sqltools.formatSql";
      when = "editorHasSelection && editorTextFocus && !config.sqltools.disableChordKeybindings && !editorReadonly";
    }
    {
      key = "ctrl+; ctrl+e";
      command = "-testing.debugFailTests";
    }
    {
      key = "ctrl+; e";
      command = "-testing.reRunFailTests";
    }
    {
      key = "ctrl+e";
      command = "-editor.action.toggleScreenReaderAccessibilityMode";
      when = "accessibilityHelpIsShown";
    }
    {
      key = "ctrl+shift+e";
      command = "-workbench.view.explorer";
      when = "viewContainer.workbench.view.explorer.enabled";
    }
    {
      key = "ctrl+enter";
      command = "-gitlens.key.ctrl+enter";
      when = "gitlens:key:ctrl+enter";
    }
    {
      key = "ctrl+k ctrl+e";
      command = "-keybindings.editor.defineWhenExpression";
      when = "inKeybindings && keybindingFocus";
    }
    {
      key = "ctrl+e";
      command = "-workbench.action.quickOpenNavigateNextInFilePicker";
      when = "inFilesPicker && inQuickOpen";
    }
    {
      key = "ctrl+shift+e";
      command = "-workbench.action.quickOpenNavigatePreviousInFilePicker";
      when = "inFilesPicker && inQuickOpen";
    }
    {
      key = "alt+e";
      command = "-gl.explainSelectedCode";
      when = "config.gitlab.duoChat.enabled && editorHasSelection && gitlab:chatAvailable && gitlab:chatAvailableForProject";
    }
    {
      key = "ctrl+b";
      command = "-workbench.action.toggleSidebarVisibility";
    }
    {
      key = "ctrl+shift+g /";
      command = "-gitlens.gitCommands";
      when = "!gitlens:disabled && config.gitlens.keymap == 'chorded'";
    }
    {
      key = "ctrl+shift+g .";
      command = "-gitlens.diffWithNext";
      when = "editorTextFocus && !isInDiffEditor && config.gitlens.keymap == 'chorded' && gitlens:activeFileStatus =~ /revision/";
    }
    {
      key = "ctrl+shift+g .";
      command = "-gitlens.diffWithNextInDiffLeft";
      when = "editorTextFocus && isInDiffEditor && !isInDiffRightEditor && config.gitlens.keymap == 'chorded' && gitlens:activeFileStatus =~ /revision/";
    }
    {
      key = "ctrl+shift+g .";
      command = "-gitlens.diffWithNextInDiffRight";
      when = "editorTextFocus && isInDiffRightEditor && config.gitlens.keymap == 'chorded' && gitlens:activeFileStatus =~ /revision/";
    }
    {
      key = "ctrl+shift+g ,";
      command = "-gitlens.diffWithPrevious";
      when = "editorTextFocus && !isInDiffEditor && config.gitlens.keymap == 'chorded' && gitlens:activeFileStatus =~ /tracked/";
    }
    {
      key = "ctrl+shift+g ,";
      command = "-gitlens.diffWithPreviousInDiffLeft";
      when = "editorTextFocus && isInDiffEditor && !isInDiffRightEditor && config.gitlens.keymap == 'chorded' && gitlens:activeFileStatus =~ /tracked/";
    }
    {
      key = "ctrl+shift+g ,";
      command = "-gitlens.diffWithPreviousInDiffRight";
      when = "editorTextFocus && isInDiffRightEditor && config.gitlens.keymap == 'chorded' && gitlens:activeFileStatus =~ /tracked/";
    }
    {
      key = "ctrl+shift+g shift+.";
      command = "-gitlens.diffWithWorking";
      when = "editorTextFocus && config.gitlens.keymap == 'chorded' && gitlens:activeFileStatus =~ /revision/";
    }
    {
      key = "ctrl+shift+g shift+,";
      command = "-gitlens.diffLineWithPrevious";
      when = "editorTextFocus && config.gitlens.keymap == 'chorded' && gitlens:activeFileStatus =~ /tracked/";
    }
    {
      key = "ctrl+shift+g c";
      command = "-gitlens.showQuickCommitFileDetails";
      when = "editorTextFocus && !gitlens:disabled && config.gitlens.keymap == 'chorded'";
    }
    {
      key = "ctrl+shift+g shift+h";
      command = "-gitlens.showQuickRepoHistory";
      when = "!gitlens:disabled && config.gitlens.keymap == 'chorded'";
    }
    {
      key = "ctrl+shift+g h";
      command = "-gitlens.showQuickFileHistory";
      when = "!gitlens:disabled && config.gitlens.keymap == 'chorded'";
    }
    {
      key = "ctrl+shift+g s";
      command = "-gitlens.showQuickRepoStatus";
      when = "!gitlens:disabled && config.gitlens.keymap == 'chorded'";
    }
    {
      key = "ctrl+shift+g b";
      command = "-gitlens.toggleFileBlame";
      when = "editorTextFocus && config.gitlens.keymap == 'chorded' && gitlens:activeFileStatus =~ /blameable/";
    }
    {
      key = "ctrl+shift+g shift+b";
      command = "-gitlens.toggleCodeLens";
      when = "editorTextFocus && !gitlens:disabled && !gitlens:disabledToggleCodeLens && config.gitlens.keymap == 'chorded'";
    }
    {
      key = "ctrl+shift+g";
      command = "-workbench.action.terminal.openDetectedLink";
      when = "accessibleViewIsShown && terminalHasBeenCreated && accessibleViewCurrentProviderId == 'terminal'";
    }
    {
      key = "ctrl+shift+g g";
      command = "-workbench.view.scm";
      when = "workbench.scm.active && !gitlens:disabled && config.gitlens.keymap == 'chorded'";
    }
    {
      key = "ctrl+shift+g";
      command = "-workbench.view.scm";
      when = "workbench.scm.active";
    }
    {
      key = "ctrl+shift+s";
      command = "-workbench.action.files.saveAs";
    }
    {
      key = "ctrl+shift+s";
      command = "-workbench.action.files.saveLocalFile";
      when = "remoteFileDialogVisible";
    }
    {
      key = "ctrl+shift+r";
      command = "-editor.action.refactor";
      when = "editorHasCodeActionsProvider && textInputFocus && !editorReadonly";
    }
    {
      key = "ctrl+shift+r";
      command = "-rerunSearchEditorSearch";
      when = "inSearchEditor";
    }
    {
      key = "ctrl+shift+r";
      command = "-workbench.action.quickOpenNavigatePreviousInRecentFilesPicker";
      when = "inQuickOpen && inRecentFilesPicker";
    }
    {
      key = "shift+alt+up";
      command = "-editor.action.insertCursorAbove";
      when = "editorTextFocus";
    }
    {
      key = "shift+alt+up";
      command = "-notebook.cell.copyUp";
      when = "notebookEditorFocused && !inputFocus";
    }
    {
      key = "shift+alt+down";
      command = "-editor.action.insertCursorBelow";
      when = "editorTextFocus";
    }
    {
      key = "shift+alt+down";
      command = "-notebook.cell.copyDown";
      when = "notebookEditorFocused && !inputFocus";
    }
    {
      key = "shift+alt+down";
      command = "editor.action.copyLinesDownAction";
      when = "editorTextFocus && !editorReadonly";
    }
    {
      key = "ctrl+shift+alt+up";
      command = "-editor.action.copyLinesUpAction";
      when = "editorTextFocus && !editorReadonly";
    }
  ];

  userSettings = (
    {
      editor.bracketPairColorization.enabled = false;
      editor.cursorBlinking = "smooth";
      editor.cursorStyle = "block";
      editor.fontFamily = "'Berkeley Mono', 'Symbols Nerd Font'";
      editor.fontLigatures = true;
      editor.fontSize = 13;
      editor.fontWeight = 400;
      editor.formatOnSave = true;
      editor.guides.bracketPairs = "active";
      editor.hover.enabled = false;
      # editor.letterSpacing = 1;
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
      terminal.integrated.fontSize = 13;
      terminal.integrated.fontWeight = 400;
      # terminal.integrated.letterSpacing = 1;
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
      javascript.updateImportsOnFileMove.enabled = "always";
      markdown.preview.fontSize = 11;
      redhat.telemetry.enabled = false;
      remote.autoForwardPortsSource = "hybrid";
      scm.inputFontSize = 11;
      security.workspace.trust.untrustedFiles = "open";
      settingsSync.ignoredSettings = [ "-window.zoomLevel" ];
      "[typescript]" = {
        editor.defaultFormatter = "esbenp.prettier-vscode";
      };
      typescript.preferGoToSourceDefinition = true;
      typescript.preferences.preferTypeOnlyAutoImports = true;
      typescript.updateImportsOnFileMove.enabled = "always";
      update.mode = "none";
      update.showReleaseNotes = false;
      window.menuBarVisibility = "toggle";
    }
  );
in

{
  config = {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;

      package = pkgs.vscode.override {
        commandLineArgs = [ "--use-gl=desktop" ];
      };

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
