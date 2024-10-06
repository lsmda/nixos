{
  enable = true;
  userName = "lsmda";
  userEmail = "contact@lsmda.pm";
  extraConfig = {
    credential.credentialStore = "secretservice";
    credential.helper = [ "manager" ];
  };
}
