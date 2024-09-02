{...}: {
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  # Store audio state on reboot
  sound.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
}
