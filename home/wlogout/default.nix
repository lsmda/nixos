{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
    ];
    style = ''
      * {
        all: unset;
        background-image: none;
      }

      window {
        background: rgba(0, 0, 0, 0.9);
      }

      button {
        font-family: "Berkeley Mono";
        font-size: 2rem;
        background-color: rgba(50, 50, 50, 0.5);
        color: #bbb;
        border-radius: 0;
        padding: 1rem;
        margin: 0 0.5rem;
      }

      button:focus,
      button:active,
      button:hover {
        background-color: rgba(80, 80, 80, 0.5);
        border-radius: 0;
      }

      #lock {
        background-image: image(url("${../assets/icons/lock.png}"));
        background-position: center;
        background-repeat: no-repeat;
        background-size: 100px;
      }

      #logout {
        background-image: image(url("${../assets/icons/logout.png}"));
        background-position: center;
        background-repeat: no-repeat;
        background-size: 110px;
      }

      #reboot {
        background-image: image(url("${../assets/icons/reboot.png}"));
        background-position: center;
        background-repeat: no-repeat;
        background-size: 110px;
      }

      #shutdown {
        background-image: image(url("${../assets/icons/shutdown.png}"));
        background-position: center;
        background-repeat: no-repeat;
        background-size: 110px;
      }
    '';
  };
}
