{ pkgs, ... }:

{
  home.packages = with pkgs; [
    librewolf
    firefoxpwa
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    nativeMessagingHosts = with pkgs; [
      firefoxpwa
    ];
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxScreenshots = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisableFormHistory = true;
      HardwareAcceleration = true;
      DisableBuiltinPDFViewer = true;
      SearchEngines = {
        Default = "DuckDuckGo";
      };
      SkipTermsOfUse = true;
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Proton Pass
        "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Progressive Web Apps for Firefox
        "firefoxpwa@filips.si" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4537285/pwas_for_firefox-2.15.0.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
      ManagedBookmarks = [ ];
    };
  };

  programs.librewolf = {
    enable = true;
    settings = {
      "identity.fxaccounts.enabled" = false;
      "image.jxl.enabled" = true; # Enable JPEG XL support
      "media.ffmpeg.vaapi.enabled" = true; # Enable VA-API hard accelaration
      "middlemouse.paste" = false;
      "svg.context-properties.content.enabled" = true;
      "webgl.disabled" = false;
      "browser.download.panel.shown" = true;
      "network.http.referer.XOriginPolicy" = 2;
      "security.OCSP.require" = false; # disable ocsp hard-fail
      "widget.use-xdg-desktop-portal.mime-handler" = 1; # set system file dialog
      "dom.w3c.touch_events.enabled" = true; # touch support aktivieren
      "browser.backspace_action" = 0; # Browser Backspace enable
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # enable theming
      "general.autoScroll" = true; # enable autoscroll
      "media.navigator.enabled" = false;
      "xpinstall.signatures.required" = false;
      "intl.accept_languages" = "en-US";
      "widget.use-xdg-desktop-portal.file-pcker" = 1;
      "privacy.firstparty.isolate" = false;
      "geo.enabled" = false;
      "dom.security.https_only_mode_ever_enabled" = true;
      "media.eme.enabled" = true;
      "privacy.resistFingerprinting" = false;
      "network.captive-portal-service.enabled" = true;
      "security.enterprise_roots.enabled" = true;
    };
  };

  # configure brave as the default browser
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "brave-browser.desktop" ];
      "x-scheme-handler/http" = [ "brave-browser.desktop" ];
      "x-scheme-handler/https" = [ "brave-browser.desktop" ];
      "x-scheme-handler/about" = [ "brave-browser.desktop" ];
      "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];
    };
  };
}
