{ config, ... }:

let
  secrets = config.sops.secrets;
  hostname = config.machine.hostname;
in

{
  programs.nushell.enable = true;
  programs.nushell.defaultEditor = true;

  programs.nushell.configFile.text = ''
    $env.OPENAI_API_KEY = (open ${secrets."user/deepseek".path})
    $env.config.show_banner = false
    $env.config.completions.external.enable = true
    $env.config.completions.external.max_results = 200

    alias .. = cd ..
    alias dd = sudo dockerd
    alias ll = ls -l
    alias ns = nix-shell
    alias ff = fastfetch
    alias gfs = gocryptfs
    alias lz = lazygit
    alias mt = mount
    alias umt = umount
    alias bios = sudo systemctl reboot --firmware-setup
    alias generations = sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
    alias rebuild = sudo nixos-rebuild switch

    # print docker output as a table
    def --wrapped d [...args] { 
      docker ...$args | split row '\n'
    }

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
      let target_volumes = ($volumes | where { |volume| $volume =~ $regex })
      
      if ($target_volumes | length) == 0 {
        echo $"No volumes found matching '$regex'"
        return
      }
      
      echo $"Found ($target_volumes | length) volumes matching '$regex'"
      
      $target_volumes | each { |volume| 
        echo $"Removing volume: $volume"

        # Find and remove any containers using this volume
        let containers = (docker ps -a --filter volume=$volume -q)

        if ($containers | length) > 0 {
          echo $"  Removing ($containers | length) containers using this volume"
          docker rm -f $containers
        }

        docker volume rm $volume
      }
    }

    def removeNixGeneration [start: int, end?: int] {
      if ($end | is-empty) {
        sudo nix-env --delete-generations $start --profile /nix/var/nix/profiles/system
      } else {
        for i in (seq $start $end) {
          sudo nix-env --delete-generations $i --profile /nix/var/nix/profiles/system
        }
      }
    }

    keychain --eval --quiet ~/.ssh/${hostname}
      | lines
      | where not ($it | is-empty)
      | parse "{k}={v}; export {k2};"
      | select k v
      | transpose --header-row
      | into record
      | load-env
  '';
}
