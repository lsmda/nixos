{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (chromium.override {
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
    discord
    eyedropper
    ffmpegthumbnailer
    firefox
    git-credential-manager
    gnome-text-editor
    gnome.eog
    gnome.gnome-calculator
    gnome.gnome-tweaks
    gnome.nautilus
    gnomeExtensions.alttab-scroll-workaround
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gparted
    impression
    imwheel
    kitty
    (mpv.override {
      scripts = [
        mpvScripts.evafast
        mpvScripts.memo
        mpvScripts.mpris
        mpvScripts.thumbfast
        mpvScripts.modernx
      ];
    })
    obsidian
    pika-backup
    protonvpn-gui
    qbittorrent
    rar
    unrar
    vscode-fhs
    wpsoffice
  ];

  programs = {
    chromium = {
      enable = true;
      homepageLocation = "about:blank";

      extensions = [
        "ghmbeldphafepmbegfdlkpapadhbakde" # Proton Pass
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "fmkadmapgofadopljbjfkapdkoienihi" # React Developer Tools
        "lmhkpmbekcpmknklioeibfkpmmfibljd" # Redux DevTools
      ];

      extraOpts = {
        BrowserSignin = 0;
        SyncDisabled = true;
        PasswordManagerEnabled = false;
        SpellcheckEnabled = true;
        SpellcheckLanguage = [
          "pt-PT"
          "en-US"
        ];
      };
    };
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user" ];
}
