{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nushell
  ];

  home.file.".config/nushell/config.nu".text = ''
    $env.config.show_banner = false

    alias .. = cd ..
    alias dd = sudo dockerd
    alias ns = nix-shell
    alias ff = fastfetch
    alias gfs = gocryptfs
    alias lz = lazygit
    alias mt = mount
    alias umt = umount
    alias bios = sudo systemctl reboot --firmware-setup
    alias generations = sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
    alias rebuild = sudo nixos-rebuild switch

    def removeDockerImages [] {
      docker images -q | split row "\n" | uniq | each { |img| docker rmi $img }
    }

    def removeDockerContainer [regex: string] {
      let containers = (docker ps -a --format "{{.Names}}" | split row "\n")
      $containers | where { |container| $container =~ $regex } | each { |container| 
        docker rm -v --force $container
      }
    }

    def removeDockerVolume [regex: string] {
      let volumes = (docker volume ls -q | split row "\n")
      $volumes | where { |volume| $volume =~ $regex } | each { |volume| 
        docker volume rm $volume
      }
    }

    def removeNixGeneration [start: int, end?: int] {
      if ($end | is-empty) {
        sudo nix-env --delete-generations $start --profile /nix/var/nix/profiles/system
      } else {
        seq $start $end | each { |i|
          sudo nix-env --delete-generations $i --profile /nix/var/nix/profiles/system
        }
      }
    }

    def removeChannelGeneration [start: int, end?: int] {
      if ($end | is-empty) {
        sudo nix-channel --remove $start
      } else {
        seq $start $end | each { |i|
          sudo nix-channel --remove $i
        }
      }
    }
  '';
}
