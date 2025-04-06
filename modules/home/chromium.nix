{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;

    dictionaries = with pkgs.hunspellDictsChromium; [
      en_US
    ];

    commandLineArgs = [
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

    extensions = [
      { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # proton pass
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "fmkadmapgofadopljbjfkapdkoienihi"; } # react developer tools
      { id = "lmhkpmbekcpmknklioeibfkpmmfibljd"; } # redux devtools
    ];
  };
}
