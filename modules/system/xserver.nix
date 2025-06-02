{ pkgs, ... }:

{

  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    excludePackages = [ pkgs.xterm ];
  };

  services.displayManager.defaultSession = "gnome";

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
    touchpad.disableWhileTyping = true;
  };

  # required to run systray icons
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  services.printing.enable = false;
  services.gnome.core-apps.enable = false;
  programs.geary.enable = false;
  documentation.nixos.enable = false;
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };

  # use pre-built cuda binaries
  nix.settings = {
    experimental-features = [
      "nix-command"
      "pipe-operators"
    ];
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  # run garbage collection whenever there is less than 500mb free space left
  nix.extraOptions = ''
    min-free = ${toString (500 * 1024 * 1024)}
  '';
}
