{ pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    librewolf
  ];

  programs.brave = {
    enable = true;
    package = pkgs.brave.override {
      commandLineArgs = [
        # hardware video acceleration flags for h.265/hevc support
        "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiIgnoreDriverChecks,PlatformHEVCDecoderSupport"
        "--disable-features=UseChromeOSDirectVideoDecoder"
        "--use-gl=desktop"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--enable-hardware-overlays"
        "--enable-oop-rasterization"

        # NVIDIA-specific acceleration
        "--ignore-gpu-blocklist"
        "--enable-gpu-sandbox"
        "--enable-accelerated-video-decode"
        "--enable-accelerated-video-encode"

        # H.265/HEVC support
        "--enable-features=PlatformHEVCDecoderSupport"
      ];
    };
    extensions = [
      { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # Proton Pass
      { id = "fmkadmapgofadopljbjfkapdkoienihi"; } # React Developer Tools
      { id = "lmhkpmbekcpmknklioeibfkpmmfibljd"; } # Redux DevTools
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
    ];
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
