{...}: {
  # Store audio state on reboot
  sound.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      wireplumber.extraConfig.disable-session-timeout = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {"node.name" = "~alsa_input.*";}
              {"node.name" = "~alsa_output.*";}
            ];
            actions.update-props = {
              "node.pause-on-idle" = false;
              "session.suspend-timeout-seconds" = 0;
            };
          }
        ];
      };
    };
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
}
