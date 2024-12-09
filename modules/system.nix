cfg:

{
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Lisbon";

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  programs.fish.enable = true;

  # allow external binaries (i.e. mason LSPs)
  programs.nix-ld.enable = true;

  # ssh
  services.openssh.enable = true;
}

// cfg # merge with configuration set passed to module
