{ config, ... }:

let
  secrets = config.sops.secrets;
  hostname = config.machine.hostname;
in

{
  programs.nushell.enable = true;

  programs.nushell.configFile.text = ''
    $env.PROMPT_COMMAND = {||
        let dir = match (do -i { $env.PWD | path relative-to $nu.home-path }) {
            null => $env.PWD
            "" => '~'
            $relative_pwd => ([~ $relative_pwd] | path join)
        }

        let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
        let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
        let path_segment = $"($path_color)($dir)(ansi reset)"

        $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
    }

    $env.PROMPT_COMMAND_RIGHT = {||
        let time_segment = ([
            (ansi reset)
            (ansi magenta)
            (date now | format date '%d/%m/%Y %H:%m')
        ] | str join | str replace --regex --all "([/:])" $"(ansi green)''${1}(ansi magenta)" |
            str replace --regex --all "([AP]M)" $"(ansi magenta_underline)''${1}")

        let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
            (ansi rb)
            ($env.LAST_EXIT_CODE)
        ] | str join)
        } else { "" }

        ([$last_exit_code, (char space), $time_segment] | str join)
    }

    $env.EDITOR = "hx"
    $env.OPENAI_API_KEY = (open ${secrets."user/deepseek".path})
    $env.config.show_banner = false # disable welcome message
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
