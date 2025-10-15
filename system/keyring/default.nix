{
  config = {
    programs.seahorse.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
