{ pkgs, ... }:

let
  keymaps = ''
    <keymap version="1" name="lsmda" parent="Visual Studio">
      <action id="ActivateDatabaseToolWindow">
        <keyboard-shortcut first-keystroke="ctrl d" />
      </action>
      <action id="ActivateFindToolWindow">
        <keyboard-shortcut first-keystroke="ctrl f" />
      </action>
      <action id="ActivateMavenToolWindow">
        <keyboard-shortcut first-keystroke="ctrl m" />
      </action>
      <action id="ActivateProjectToolWindow">
        <keyboard-shortcut first-keystroke="ctrl e" />
      </action>
      <action id="ActivateRunToolWindow">
        <keyboard-shortcut first-keystroke="alt r" />
      </action>
      <action id="ActivateTerminalToolWindow">
        <keyboard-shortcut first-keystroke="alt w" />
      </action>
      <action id="ChangesView.SetDefault" />
      <action id="CloseActiveTab">
        <keyboard-shortcut first-keystroke="ctrl w" />
      </action>
      <action id="CloseAllEditors">
        <keyboard-shortcut first-keystroke="ctrl k" second-keystroke="w" />
      </action>
      <action id="CloseContent">
        <keyboard-shortcut first-keystroke="ctrl w" />
      </action>
      <action id="CodeCleanup" />
      <action id="CodeCompletion" />
      <action id="CollapseAllRegions" />
      <action id="CollapseRegion" />
      <action id="CollapseSelection" />
      <action id="CollapsiblePanel-toggle" />
      <action id="Compare.SameVersion" />
      <action id="CompareTwoFiles" />
      <action id="Console.TableResult.CloneRow" />
      <action id="Console.TableResult.ColumnVisibility" />
      <action id="Console.TableResult.FindInGrid" />
      <action id="Diff.ShowDiff" />
      <action id="EditorDuplicate" />
      <action id="EditorScrollToCenter" />
      <action id="EditorSelectWord" />
      <action id="EditorToggleUseSoftWraps" />
      <action id="ExpandAllRegions" />
      <action id="ExpandCollapseToggleAction" />
      <action id="ExpandRecursively" />
      <action id="ExpandRegion" />
      <action id="FileChooser.GotoDesktop" />
      <action id="FileChooser.TogglePathBar" />
      <action id="Find" />
      <action id="FindInPath" />
      <action id="FindSelectionInPath" />
      <action id="FindUsages" />
      <action id="ForceOthersToFollowAction" />
      <action id="Frontend.ChangesView.ShowDiff" />
      <action id="GotoFile">
        <keyboard-shortcut first-keystroke="ctrl p" />
      </action>
      <action id="HideActiveWindow">
        <keyboard-shortcut first-keystroke="escape" />
      </action>
      <action id="InsertLiveTemplate" />
      <action id="Markdown.Preview.Find" />
      <action id="MaximizeToolWindow">
        <keyboard-shortcut first-keystroke="alt x" />
      </action>
      <action id="Print" />
      <action id="QuickPreview" />
      <action id="RunDashboard.CopyConfiguration" />
      <action id="SearchEverywhere">
        <keyboard-shortcut first-keystroke="shift ctrl f" />
      </action>
      <action id="SendEOF" />
      <action id="ShowBookmarks" />
      <action id="ShowSettings">
        <keyboard-shortcut first-keystroke="shift ctrl o" />
      </action>
      <action id="SilentCodeCleanup" />
      <action id="SmartSelect" />
      <action id="SpeedSearch" />
      <action id="SplitChooser.SplitCenter" />
      <action id="SurroundWithLiveTemplate" />
      <action id="SwitcherIterateItems" />
      <action id="SwitcherRecentEditedChangedToggleCheckBox" />
      <action id="TableResult.GrowSelection" />
      <action id="TableResult.SelectColumn" />
      <action id="Terminal.CloseSession" />
      <action id="Terminal.DeletePreviousWord" />
      <action id="Terminal.NewTab">
        <keyboard-shortcut first-keystroke="ctrl space" />
      </action>
      <action id="TypeHierarchy" />
      <action id="TypeHierarchyBase.BaseOnThisType" />
      <action id="Unscramble" />
      <action id="UsageFiltering.WriteAccess" />
      <action id="XDebugger.CopyWatch" />
      <action id="openAssertEqualsDiff" />
    </keymap>
  '';
in

{
  home.packages = with pkgs; [
    bruno
    jetbrains.idea-ultimate
    jetbrains.webstorm
    maven
    openjdk17
  ];

  home.file.".config/JetBrains/IntelliJIdea2025.1/keymaps/lsmda.xml".text = keymaps;
}
