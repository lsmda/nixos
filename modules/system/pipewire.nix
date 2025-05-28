{
  # store sound state on reboot
  hardware.alsa.enablePersistence = true;

  security.rtkit.enable = true;

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # on laptop, the `node.pause-on-idle` action is called when no sound is being played.
    # this action produces an annoying 'pop' sound, which becomes even more annoying when
    # you hear it hundreds of times during your session. disabling it to keep my sanity.
    wireplumber.extraConfig.disable-session-timeout."monitor.alsa.rules" = [
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
}
