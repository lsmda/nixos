{ pkgs, ... }:

{
  programs.chromium.enable = true;
  programs.chromium.package = pkgs.chromium;

  programs.chromium.dictionaries = with pkgs.hunspellDictsChromium; [
    en_US
  ];

  programs.chromium.commandLineArgs = [
    # performance
    "--enable-gpu-rasterization"
    "--enable-oop-rasterization"
    "--enable-zero-copy"
    "--ignore-gpu-blocklist"

    # misc
    "--no-default-browser-check"
    "--no-service-autorun"
    "--disable-features=PreloadMediaEngagementData,MediaEngagementBypassAutoplayPolicies"
    "--no-pings"
    "--no-first-run"
    "--no-experiments"
    "--no-crash-upload"
    "--disable-wake-on-wifi"
    "--disable-breakpad"
    "--disable-sync"
    "--disable-speech-api"
    "--disable-speech-synthesis-api"
  ];

  programs.chromium.extensions = [
    { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # proton pass
    { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
    { id = "fmkadmapgofadopljbjfkapdkoienihi"; } # react developer tools
    { id = "lmhkpmbekcpmknklioeibfkpmmfibljd"; } # redux devtools
  ];
}
