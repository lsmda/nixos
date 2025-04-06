{
  programs.fish = {
    enable = true;

    shellInit = ''
      set -U fish_greeting # disable greeting
      set -U fish_cursor_default block blink
    '';

    shellAliases = {
      ".." = "cd ..";
      dd = "sudo dockerd";
      ns = "nix-shell";
      ff = "fastfetch";
      gfs = "gocryptfs";
      ll = "ls -laht";
      lz = "lazygit";
      mt = "mount";
      umt = "umount";
      bios = "sudo systemctl reboot --firmware-setup";
      generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      rebuild = "sudo nixos-rebuild switch";
    };

    functions = {
      fish_prompt = ''
        echo -n (set_color blue)(prompt_pwd)" "
      '';

      removeDockerImages = ''
        docker rmi (docker images -q)
      '';

      removeDockerContainer = ''
        set -l regex $argv[1]

        # get all container names
        set -l containers (docker ps -a --format "{{.Names}}")

        # filter containers based on the regex
        for container in $containers
          if echo $container | grep -qE $regex
            docker rm -v --force $container
          end
        end
      '';

      removeDockerVolume = ''
        set -l regex $argv[1]

        # get all volume names
        set -l volumes (docker volume ls -q)

        # filter volumes based on the regex
        for volume in $volumes
          if echo $volume | grep -qE $regex
            docker volume rm $volume
          end
        end
      '';

      removeNixGeneration = ''
        set -l start $argv[1]
        set -l end $argv[2]

        if test (count $argv) -eq 1
          # only one argument provided, delete that single generation
          sudo nix-env --delete-generations $start --profile /nix/var/nix/profiles/system
        else if test (count $argv) -eq 2
          # two arguments provided, delete the range of generations
          for i in (seq (math $start) (math $end))
            sudo nix-env --delete-generations $i --profile /nix/var/nix/profiles/system
          end
        else
          echo "Usage: removeNixGeneration <start> [end]"
        end
      '';
    };
  };
}
