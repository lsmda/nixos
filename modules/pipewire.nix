{ ... }:

{
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

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
              { "node.name" = "~alsa_input.*"; }
              { "node.name" = "~alsa_output.*"; }
            ];
            actions.update-props = {
              "node.pause-on-idle" = false;
              "session.suspend-timeout-seconds" = 0;
            };
          }
        ];
      };

      wireplumber.extraConfig.bluetooth-enhancements = {
        "monitor.bluez.rules" = [
          {
            matches = [ { "node.name" = "~bluez_card.*"; } ];
            actions.update-props = {
              "bluez5.auto-connect" = [
                "a2dp_sink"
                "a2dp_source"
              ];
              "bluez5.hw-volume" = [
                "a2dp_sink"
                "a2dp_source"
              ];
            };
          }
        ];
      };
    };
  };
}
