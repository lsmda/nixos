{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkForce;
  inherit (import ../../utils { inherit config lib; }) createUsersGroups usersGroups;
  secrets = config.sops.secrets;
in

{
  imports = [
    "${fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops"
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz"}/nixos"

    ./hardware.nix

    ../../system/bluetooth.nix
    ../../system/boot.nix
    ../../system/fonts.nix
    ../../system/gnome.nix
    ../../system/keyd.nix
    ../../system/locale.nix
    ../../system/networking.nix
    ../../system/nfs-client.nix
    ../../system/openssh.nix
    ../../system/pipewire.nix
    ../../system/postgresql.nix
    ../../system/settings.nix
    ../../system/sops.nix
    ../../system/virtualisation.nix
  ];

  config = {
    system.stateVersion = "25.05";

    machine.username = "user";
    machine.hostname = "spellbook";

    console.keyMap = "pt-latin1";
    services.xserver.xkb.layout = "pt";

    environment.variables = {
      # XDG_CURRENT_DESKTOP = "wayland";      # Sets the current desktop environment to Wayland.
      # XDG_SESSION_TYPE = "wayland";         # Defines the session type as Wayland.
      # __GLX_VENDOR_LIBRARY_NAME = "mesa";         # Specifies the GLX vendor library to use, ensuring Mesa's library is used
      CLUTTER_BACKEND = "wayland"; # Specifies Wayland as the backend for Clutter.
      LIBVA_DRIVER_NAME = "intel"; # Force Intel i965 driver
      MOZ_ENABLE_WAYLAND = "1"; # Enables Wayland support in Mozilla applications (e.g., Firefox).
      NIXOS_OZONE_WL = "1"; # Enables the Ozone Wayland backend for Chromium-based browsers.
      NIXPKGS_ALLOW_UNFREE = "1"; # Allows the installation of packages with unfree licenses in Nixpkgs.
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # Disables window decorations in Qt applications when using Wayland.
      SDL_VIDEODRIVER = "wayland"; # Sets the video driver for SDL applications to Wayland.
      TOLGAOS_VERSION = "2.2";
      TOLGAOS = "true";
    };

    # -----------------------------------------------
    # Enables simultaneous use of processor threads.
    # -----------------------------------------------
    security = {
      allowSimultaneousMultithreading = true; # Allow simultaneous multithreading (SMT).
      rtkit.enable = true; # Enable RealtimeKit (rtkit) for managing real-time priorities.
    };

    users.groups = createUsersGroups usersGroups;

    users.users.${config.machine.username} = {
      home = "/home/${config.machine.username}";
      uid = 1000;
      isNormalUser = true;
      group = "users";
      shell = pkgs.nushell;
      hashedPasswordFile = secrets."password".path;
      extraGroups = usersGroups;
    };

    home-manager.users.${config.machine.username} = {
      imports = [
        ../../home/dconf.nix
        ../../home/fastfetch.nix
        ../../home/ghostty.nix
        ../../home/gpg.nix
        ../../home/gtk.nix
        ../../home/helix.nix
        ../../home/keybinds.nix
        ../../home/mpv.nix
        ../../home/packages.nix
        ../../home/shell.nix
        ../../home/vscode.nix
        ../../home/zed.nix

        (import ../../home/browser.nix { inherit config pkgs; })
        (import ../../home/codecs.nix { inherit config pkgs; })
        (import ../../home/git.nix { inherit config pkgs; })
        (import ../../home/nushell.nix { inherit config; })
      ];

      dconf.settings = {
        "org/gnome/desktop/interface"."text-scaling-factor" = mkForce 0.8;
      };

      home.stateVersion = "25.05";
    };

    home-manager.backupFileExtension = "backup";
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
