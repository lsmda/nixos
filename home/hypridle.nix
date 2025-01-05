{
  services.hypridle.enable = true;

  services.hypridle.settings.general = {
    lock_cmd = "hyprlock";
    before_sleep_cmd = "loginctl lock-session";
    after_sleep_cmd = "hyprctl dispatch dpms on";
  };

  services.hypridle.settings.listener = [
    {
      timeout = 900; # 15 minutes
      on-timeout = "hyprlock";
    }

    {
      timeout = 1200; # 20 minutes
      on-timeout = "hyprctl dispatch dpms off";
      on-resume = "hyprctl dispatch dpms on";
    }
  ];
}
