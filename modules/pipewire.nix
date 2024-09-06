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

      wireplumber.extraConfig.bluetooth-enhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
        };
      };
    };
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
}
