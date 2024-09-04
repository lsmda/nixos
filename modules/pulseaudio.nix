{...}: {
  # Store audio state on reboot
  sound.enable = true;

  nixpkgs.config.pulseaudio = true;

  hardware = {
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;

    pulseaudio.extraConfig = ''
      unload-module module-suspend-on-idle
    '';
  };
}
