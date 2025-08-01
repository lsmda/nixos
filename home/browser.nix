{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    librewolf
    firefoxpwa
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts = with pkgs; [
      firefoxpwa
    ];
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      search = {
        force = true;
        engines = {
          nix = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "lang%3Anix+{searchTerms}";
                  }
                  {
                    name = "type";
                    value = "code";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
            definedAliases = [ "@nix" ];
          };
          ts = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "lang%3Atypescript+{searchTerms}";
                  }
                  {
                    name = "type";
                    value = "code";
                  }
                ];
              }
            ];
            definedAliases = [ "@ts" ];
          };
          home-manager = {
            urls = [
              {
                template = "https://home-manager-options.extranix.com";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "release";
                    value = "release-${config.system.stateVersion}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
            definedAliases = [ "@home" ];
          };
          nix-packages = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "channel";
                    value = config.system.stateVersion;
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
            definedAliases = [ "@pkg" ];
          };
          nix-options = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "channel";
                    value = config.system.stateVersion;
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
            definedAliases = [ "@opt" ];
          };
          noogle = {
            urls = [
              {
                template = "https://noogle.dev/q";
                params = [
                  {
                    name = "term";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
            definedAliases = [ "@noogle" ];
          };
        };
      };
      settings = {
        "apz.gtk.kinetic_scroll.enabled" = false; # Disable kinetic scrolling for smoother scroll behavior
        "browser.aboutConfig.showWarning" = false; # Disable warning when accessing about:config
        "browser.in-content.dark-mode" = true; # Enable dark mode for browser content
        "browser.startup.page" = 3; # Set startup page to restore previous session
        "browser.tabs.closeTabByDblclick" = true; # Enable closing tabs with double-click
        "browser.tabs.groups.dragOverThresholdPercent" = 10; # Set threshold for tab group dragging
        "browser.tabs.loadInBackground" = true; # Load tabs in the background automatically
        "browser.tabs.tabMinWidth" = 75; # Set minimum tab width to prevent scrolling
        "browser.toolbars.bookmarks.visibility" = true; # Always show bookmarks toolbar
        "browser.urlbar.placeholderName" = "DuckDuckGo"; # Set default search engine placeholder to DuckDuckGo
        "browser.urlbar.placeholderName.private" = "DuckDuckGo"; # Set private browsing search engine placeholder to DuckDuckGo
        "browser.urlbar.shortcuts.bookmarks" = false; # Disable bookmark suggestions in URL bar
        "browser.urlbar.shortcuts.history" = false; # Disable history suggestions in URL bar
        "browser.urlbar.shortcuts.tabs" = false; # Disable tab suggestions in URL bar
        "browser.urlbar.suggest.calculator" = true; # Enable calculator suggestions in URL bar
        "browser.urlbar.suggest.searches" = true; # Enable basic search suggestions in URL bar
        "browser.urlbar.trimHttps" = true; # Trim HTTPS from URL bar for cleaner display
        "browser.urlbar.unitConversion.enabled" = true; # Enable unit conversion in URL bar
        "browser.warnOnQuitShortcut" = false; # Disable warning when quitting with shortcut
        "cookiebanners.service.mode" = 2; # Enable strict cookie banner blocking
        "cookiebanners.service.mode.privateBrowsing" = 2; # Enable strict cookie banner blocking in private browsing
        "dom.w3c_touch_events.enabled" = 1; # Enable W3C touch events
        "extensions.autoDisableScopes" = 0; # Automatically enable all extensions
        "extensions.update.enabled" = false; # Disable automatic extension updates
        "gfx.webrender.all" = true; # Enable WebRender for improved rendering performance
        "layers.acceleration.force-enabled" = true; # Force-enable layer acceleration
        "media.av1.enabled" = false; # Disable AV1 video codec
        "media.ffmpeg.vaapi.enabled" = true; # Enable hardware acceleration via FFmpeg VAAPI
        "media.hardware-video-decoding.force-enabled" = true; # Force-enable hardware video decoding
        "media.rdd-ffmpeg.enabled" = true; # Enable FFmpeg in Remote Data Decoder
        "ui.systemUsesDarkTheme" = true; # Enable system-wide dark theme
        "widget.dmabuf.force-enabled" = true; # Force-enable DMA-BUF for better performance
        "widget.use-xdg-desktop-portal" = true; # Enable XDG desktop portal integration
        "widget.use-xdg-desktop-portal.file-picker" = 1; # Use GTK file picker via XDG portal
        "widget.use-xdg-desktop-portal.mime-handler" = 1; # Use XDG portal for MIME handling
      };
    };
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      CaptivePortal = false;
      DisableAccounts = true;
      DisableBuiltinPDFViewer = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisablePocket = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "never";
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        Locked = true;
      };
      Extensions = {
        Install = [
          "https://addons.mozilla.org/firefox/downloads/latest/consent-o-matic/latest.xpi"
          "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi"
          "https://addons.mozilla.org/firefox/downloads/latest/lastpass-password-manager/latest.xpi"
          "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
          "https://addons.mozilla.org/firefox/downloads/file/3879908/perfectdarktheme-1.1.xpi"
          "https://addons.mozilla.org/firefox/downloads/file/4537285/pwas_for_firefox-2.15.0.xpi"
        ];
      };
      FirefoxHome = {
        Search = false;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      HardwareAcceleration = true;
      Homepage = {
        StartPage = "previous-session";
        Locked = true;
      };
      NewTabPage = false;
      OfferToSaveLogins = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;
      PictureInPicture = {
        Enabled = false;
        Locked = true;
      };
      PopupBlocking = {
        "Default" = true;
      };
      PrimaryPassword = false;
      PromptForDownloadLocation = true;
      SanitizeOnShutdown = {
        Cache = true;
        Cookies = false;
        Downloads = true;
        FormData = true;
        History = false;
        Sessions = false;
        SiteSettings = false;
        Locked = true;
      };
      SearchBar = "unified";
      SearchEngines = {
        Default = "DuckDuckGo";
        Remove = [
          "Google"
          "Bing"
          "Yahoo"
          "Amazon.com"
          "eBay"
          "Wikipedia (en)"
        ];
      };
      SkipTermsOfUse = true;
      TranslateEnabled = false;
      UserMessaging = {
        "WhatsNew" = false;
        "ExtensionRecommendations" = false;
        "FeatureRecommendations" = false;
        "UrlbarInterventions" = false;
        "SkipOnboarding" = true;
        "MoreFromMozilla" = false;
        "Locked" = false;
      };
    };
  };
}
