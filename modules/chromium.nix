{
  programs.chromium.enable = true;
  programs.chromium.homepageLocation = "about:blank";

  programs.chromium.extensions = [
    "ghmbeldphafepmbegfdlkpapadhbakde" # Proton Pass
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    "fmkadmapgofadopljbjfkapdkoienihi" # React Developer Tools
    "lmhkpmbekcpmknklioeibfkpmmfibljd" # Redux DevTools
  ];

  programs.chromium.extraOpts = {
    BrowserSignin = 0;
    SyncDisabled = true;
    PasswordManagerEnabled = false;
    SpellcheckEnabled = true;
    SpellcheckLanguage = [
      "pt-PT"
      "en-US"
    ];
  };
}
