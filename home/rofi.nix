{ pkgs, ... }:

let
  color = import ../themes/metal;
  theme = import ../modules/theme.nix;
in

{
  rofi = {
    enable = true;

    package = pkgs.rofi-wayland.override {
      plugins = with pkgs; [
        rofi-emoji
        rofi-vpn
        rofi-power-menu
      ];
    };

    theme = builtins.toString (
      pkgs.writeText "rofi-theme" ''
        configuration {
          modi:                       "drun,run,filebrowser";
            show-icons:                 false;
            display-drun:               "";
            display-run:                "";
            display-filebrowser:        "";
          window-format:              "{w}  {c}";
        }

        * {
            background:     #101010E5;
            background-alt: #101010E5;
            foreground:     ${color.base05};
            selected:       ${color.base05};
            active:         ${color.base0B};
            urgent:         ${color.base08};

            border-colour:               var(selected);
            handle-colour:               var(foreground);
            background-colour:           var(background);
            foreground-colour:           var(foreground);
            alternate-background:        var(background-alt);
            normal-background:           var(background);
            normal-foreground:           var(foreground);
            urgent-background:           var(urgent);
            urgent-foreground:           var(background);
            active-background:           var(active);
            active-foreground:           var(background);
            selected-normal-background:  var(selected);
            selected-normal-foreground:  var(background);
            selected-urgent-background:  var(active);
            selected-urgent-foreground:  var(background);
            selected-active-background:  var(urgent);
            selected-active-foreground:  var(background);
            alternate-normal-background: var(background);
            alternate-normal-foreground: var(foreground);
            alternate-urgent-background: var(urgent);
            alternate-urgent-foreground: var(background);
            alternate-active-background: var(active);
            alternate-active-foreground: var(background);
        }

        window {
            /* properties for window widget */
            transparency:                "real";
            location:                    center;
            anchor:                      center;
            fullscreen:                  false;
            width:                       400px;
            x-offset:                    0px;
            y-offset:                    0px;

            /* properties for all widgets */
            enabled:                     true;
            margin:                      0px;
            padding:                     0px;
            border:                      ${toString theme.border}px solid;
            border-radius:               ${toString theme.spacing_md}px;
            border-color:                @selected;
            cursor:                      "default";
            background-color:            @background-colour;
        }

        mainbox {
            enabled:                     true;
            spacing:                     ${toString theme.spacing_lg}px;
            margin:                      0px;
            padding:                     30px;
            border:                      0px solid;
            border-radius:               0px 0px 0px 0px;
            border-color:                @border-colour;
            background-color:            transparent;
            children:                    [ "inputbar", "message", "listview" ];
            child-spacing:               ${toString theme.spacing_md}px;
        }

        inputbar {
            enabled:                     true;
            spacing:                     ${toString theme.spacing_lg}px;
            margin:                      0 0 ${toString theme.spacing_lg}px 0;
            padding:                     0px;
            border:                      0px solid;
            border-radius:               0px;
            border-color:                @border-colour;
            background-color:            transparent;
            text-color:                  @foreground-colour;
            children:                    [ "entry" ];
        }

        prompt {
            enabled:                     true;
            background-color:            inherit;
            text-color:                  inherit;
        }

        textbox-prompt-colon {
            enabled:                     true;
            expand:                      false;
            str:                         "::";
            background-color:            inherit;
            text-color:                  inherit;
        }

        entry {
            enabled:                     true;
            background-color:            inherit;
            text-color:                  inherit;
            cursor:                      text;
            placeholder:                 "Search...";
            placeholder-color:           inherit;
        }

        num-filtered-rows {
            enabled:                     true;
            expand:                      false;
            background-color:            inherit;
            text-color:                  inherit;
        }

        textbox-num-sep {
            enabled:                     true;
            expand:                      false;
            str:                         "/";
            background-color:            inherit;
            text-color:                  inherit;
        }

        num-rows {
            enabled:                     true;
            expand:                      false;
            background-color:            inherit;
            text-color:                  inherit;
        }

        case-indicator {
            enabled:                     true;
            background-color:            inherit;
            text-color:                  inherit;
        }

        listview {
            enabled:                     true;
            columns:                     1;
            lines:                       5;
            cycle:                       true;
            dynamic:                     true;
            scrollbar:                   false;
            layout:                      vertical;
            reverse:                     false;
            fixed-height:                true;
            fixed-columns:               true;
            
            spacing:                     ${toString theme.spacing_md}px;
            margin:                      0px;
            padding:                     0px;
            border:                      0px solid;
            border-radius:               0px;
            border-color:                @border-colour;
            background-color:            transparent;
            text-color:                  @foreground-colour;
            cursor:                      "default";
            transparent:                 true;
        }

        element {
            enabled:                     true;
            spacing:                     ${toString theme.spacing}px;
            margin:                      0px;
            padding:                     ${toString (theme.spacing_md * 2)}px;
            border:                      0px solid;
            border-radius:               ${toString (theme.radius / 2)}px;
            border-color:                @border-colour;
            background-color:            transparent;
            text-color:                  @foreground-colour;
            cursor:                      pointer;
        }

        element normal.urgent {
            background-color:            var(urgent-background);
            text-color:                  var(urgent-foreground);
        }

        element normal.active {
            background-color:            var(active-background);
            text-color:                  var(active-foreground);
        }

        element selected.normal {
            background-color:            var(normal-foreground);
            text-color:                  var(normal-background);
        }

        element selected.urgent {
            background-color:            var(selected-urgent-background);
            text-color:                  var(selected-urgent-foreground);
        }

        element selected.active {
            background-color:            var(selected-active-background);
            text-color:                  var(selected-active-foreground);
        }

        element alternate.urgent {
            background-color:            var(alternate-urgent-background);
            text-color:                  var(alternate-urgent-foreground);
        }

        element alternate.active {
            background-color:            var(alternate-active-background);
            text-color:                  var(alternate-active-foreground);
        }

        element-icon {
            background-color:            transparent;
            text-color:                  inherit;
            size:                        20px;
            cursor:                      inherit;
        }

        element-text {
            background-color:            transparent;
            text-color:                  inherit;
            highlight:                   inherit;
            cursor:                      inherit;
            vertical-align:              0.5;
            horizontal-align:            0.0;
        }

        textbox {
            padding:                     8px;
            border:                      0px solid;
            border-radius:               ${toString (theme.radius / 2)}px;
            border-color:                @border-colour;
            background-color:            @alternate-background;
            text-color:                  @foreground-colour;
            vertical-align:              0.5;
            horizontal-align:            0.0;
            highlight:                   none;
            placeholder-color:           @foreground-colour;
            blink:                       true;
            markup:                      true;
        }

        error-message {
            padding:                     ${toString theme.spacing_lg}px;
            border:                      0px solid;
            border-radius:               ${toString (theme.radius / 2)}px;
            border-color:                @border-colour;
            background-color:            @background-colour;
            text-color:                  @foreground-colour;
        }
      ''
    );
  };
}
