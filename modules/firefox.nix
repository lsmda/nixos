{ pkgs, ... }:

{
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-devedition;

  programs.firefox.policies = {
    CaptivePortal = false;
    DisableAccounts = true;
    DisableFirefoxAccounts = true;
    DisableFirefoxScreenshots = true;
    DisableFirefoxStudies = true;
    DisableFormHistory = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DontCheckDefaultBrowser = true;

    EnableTrackingProtection = {
      Cryptomining = true;
      Fingerprinting = true;
      Locked = true;
      Value = true;
    };

    ExtensionSettings = {
      "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
        "installation_mode" = "force_installed";
        "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
        "default_area" = "navbar";
      };
      "uBlock0@raymondhill.net" = {
        "installation_mode" = "force_installed";
        "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        "default_area" = "navbar";
      };
    };

    FirefoxHome = {
      Highlights = false;
      Pocket = false;
      Snippets = false;
      TopSites = false;
    };

    Homepage = {
      StartPage = "none";
    };

    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;

    SanitizeOnShutdown = true;

    SearchEngines = {
      Default = "DuckDuckGo";
      PreventInstalls = true;
      Remove = [
        "Bing"
        "Google"
        "Qwant"
        "Wikipedia (en)"
      ];
    };

    SearchSuggestEnabled = false;

    UserMessaging = {
      ExtensionRecommendations = false;
      FeatureRecommendations = false;
      SkipOnboarding = true;
      MoreFromMozilla = false;
      FirefoxLabs = false;
    };

  };

  programs.firefox.preferences = {
    "extensions.pocket.enabled" = false;
    "extensions.screenshots.disabled" = true;
    # use native GTK buttons
    "widget.gtk.non-native-titlebar-buttons.enabled" = false;
    "widget.use-xdg-desktop-portal.file-picker" = true;
  };
}
