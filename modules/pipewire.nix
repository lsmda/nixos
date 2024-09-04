{...}: {
  # Store audio state on reboot
  sound.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      wireplumber.extraConfig = {
      };
    };
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
}
