let
  gateway = "10.0.0.1";
in
{
  desktop = {
    address = "10.0.0.10";
    gateway = gateway;
    hostname = "desktop";
    interface = "eno1";
  };

  laptop = {
    address = "10.0.0.11";
    gateway = gateway;
    hostname = "laptop";
    interface = "wlp0s20f3";
  };

  server = {
    address = "10.0.0.5";
    gateway = gateway;
    hostname = "server";
    interface = "end0";
  };
}
