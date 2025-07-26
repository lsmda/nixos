{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    librewolf
    firefoxpwa # Support for PWAs
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts = with pkgs; [
      firefoxpwa
    ];
    profiles.${config.machine.username} = {
      id = 0;
      name = config.machine.username;
      isDefault = true;
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Homepage";
            url = "https://nixos.org/";
          }
        ];
      };
    };
    policies = {
      DontCheckDefaultBrowser = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxAccounts = true;
      NoDefaultBookmarks = true;

      CaptivePortal = false;

      DisplayBookmarksToolbar = true;
      DisplayMenuBar = "never"; # Previously appeared when pressing alt

      OverrideFirstRunPage = "";
      PictureInPicture.Enabled = false;
      PromptForDownloadLocation = false;

      HardwareAcceleration = true;
      TranslateEnabled = true;

      Homepage.StartPage = "previous-session";

      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      # Make new tab only show search
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
      };

      UserMessaging = {
        UrlbarInterventions = false;
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };

      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      OverridePostUpdatePage = "";
      DisableFormHistory = true;
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
    };
    policies.Preferences = {
      "browser.startup.page" = 3;
      "browser.urlbar.suggest.calculator" = true;
      "browser.urlbar.unitConversion.enabled" = true;
      "browser.urlbar.trimHttps" = true;
      "browser.urlbar.suggest.searches" = true; # Need this for basic search suggestions
      "browser.urlbar.shortcuts.bookmarks" = false;
      "browser.urlbar.shortcuts.history" = false;
      "browser.urlbar.shortcuts.tabs" = false;
      "browser.tabs.tabMinWidth" = 75; # Make tabs able to be smaller to prevent scrolling
      "browser.urlbar.placeholderName" = "DuckDuckGo";
      "browser.urlbar.placeholderName.private" = "DuckDuckGo";
      "browser.aboutConfig.showWarning" = false; # No warning when going to config
      "browser.warnOnQuitShortcut" = false;
      "browser.tabs.groups.dragOverThresholdPercent" = 10;
      "browser.tabs.loadInBackground" = true; # Load tabs automatically
      "browser.tabs.closeTabByDblclick" = true;
      "browser.toolbars.bookmarks.visibility" = "always";

      "media.ffmpeg.vaapi.enabled" = true; # Enable hardware acceleration
      "media.av1.enabled" = false;
      "media.hardware-video-decoding.force-enabled" = true;
      "media.rdd-ffmpeg.enabled" = true;

      "layers.acceleration.force-enabled" = true;
      "gfx.webrender.all" = true;

      "browser.in-content.dark-mode" = true; # Use dark mode
      "ui.systemUsesDarkTheme" = true;

      "extensions.autoDisableScopes" = 0; # Automatically enable extensions
      "extensions.update.enabled" = false;

      "widget.dmabuf.force-enabled" = true;
      "dom.w3c_touch_events.enabled" = 1;

      "widget.use-xdg-desktop-portal" = true;
      "widget.use-xdg-desktop-portal.file-picker" = 1; # Use new gtk file picker instead of legacy one
      "widget.use-xdg-desktop-portal.mime-handler" = 1;

      "apz.gtk.kinetic_scroll.enabled" = false;
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
