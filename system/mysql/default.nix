{
  virtualisation.oci-containers.containers."mysql" = {
    image = "mysql:8.3";
    serviceName = "mysql";
    environment = {
      MYSQL_DATABASE = "store";
      MYSQL_USER = "store";
      MYSQL_PASSWORD = "store";
      MYSQL_ROOT_PASSWORD = "store";
    };
    cmd = [
      "--default-storage-engine"
      "innodb"
    ];
    volumes = [
      "/var/lib/mysql:/var/lib/mysql"
    ];
    ports = [
      "8003:3306"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/mysql 0770 root root - -"
  ];
}
