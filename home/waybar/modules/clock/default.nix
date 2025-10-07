{
  config = {
    programs.waybar = {
      settings.main = {
        "clock#time" = {
          format = "{:%H:%M}";
          min-length = 5;
          max-length = 5;
          tooltip-format = "Standard Time: {:%I:%M %p}";
        };
        "clock#date" = {
          format = "󰸗 {:%Y-%m-%d}";
          min-length = 14;
          max-length = 14;
          tooltip-format = "{calendar}";
          calendar = {
            mode = "month";
            mode-mon-col = 6;
            format = {
              months = "<span alpha='100%'><b>{}</b></span>";
              days = "<span alpha='90%'>{}</span>";
              weekdays = "<span alpha='80%'><i>{}</i></span>";
              today = "<span alpha='100%'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click = "mode";
          };
        };
      };
      style = ''
        #clock.time {
        	padding-left: 10px;
        	padding-right: 10px;
        	background-color: @time;
        }
        #clock.date {
        	padding-left: 7px;
        	padding-right: 7px;
        	background-color: @date;
        }
      '';
    };
  };
}
