{
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
      "privacy.resistFingerprinting" = true;
      "network.captive-portal-service.enabled" = true;
      "security.enterprise_roots.enabled" = true;
    };
  };
}
