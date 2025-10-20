{ pkgs, ... }:

let
  menu = pkgs.writeText "menu.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
       <object class="GtkMenu" id="menu">
          <child>
             <object class="GtkMenuItem" id="suspend">
                <property name="label">Suspend</property>
             </object>
          </child>
          <child>
             <object class="GtkMenuItem" id="hibernate">
                <property name="label">Hibernate</property>
             </object>
          </child>
          <child>
             <object class="GtkMenuItem" id="reboot">
                <property name="label">Reboot</property>
             </object>
          </child>
          <child>
             <object class="GtkMenuItem" id="shutdown">
                <property name="label">Shutdown</property>
             </object>
          </child>
       </object>
    </interface>
  '';
in

{
  config.programs.waybar = {
    settings.main = {
      "custom/power" = {
        format = "⏻";
        tooltip = false;
        "menu" = "on-click";
        "menu-file" = menu;
        "menu-actions" = {
          "shutdown" = "shutdown";
          "reboot" = "reboot";
          "suspend" = "systemctl suspend";
          "hibernate" = "systemctl hibernate";
        };
      };
    };
    style = ''
      #custom-power {
      	padding: 0 12px;
      	font-size: 18px;
      	background-color: @main-bg;
      	border-radius: 0;
      }
      #custom-power:hover {
      	background-color: @hover-bg;
      }
    '';
  };
}
