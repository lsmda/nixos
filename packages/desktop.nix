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
    spotify
    rar
    unrar
    vscode-fhs
    wpsoffice
  ];
}
