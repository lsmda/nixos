{ ... }:

{
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
}
