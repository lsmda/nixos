{ config, ... }:

let
  secrets = config.sops.secrets;
  hostname = config.machine.hostname;
in

{
  programs.nushell = {
    enable = true;

    shellAliases = {
      ".." = "cd ..";
      dd = "sudo dockerd";
      rr = "ranger";
      ll = "ls -l";
      ns = "nix-shell";
      ff = "fastfetch";
      cfs = "cryfs";
      gfs = "gocryptfs";
      lz = "lazygit";
      mt = "mount";
      umt = "umount";
      mk = "mkdir";
      mv = "mv --verbose";
      cp = "cp --verbose --recursive --progress";
      rm = "rm --verbose --recursive";
      bios = "sudo systemctl reboot --firmware-setup";
      rebuild = "sudo nixos-rebuild switch --show-trace";
      generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    };

    configFile.text = ''
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
      $env.PROMPT_COMMAND_RIGHT = ""

      $env.EDITOR = "hx"
      $env.OPENAI_API_KEY = (open ${secrets."user/deepseek".path})

      $env.config.show_banner = false # disable welcome message
      $env.config.datetime_format = {}
      $env.config.buffer_editor = ""
      $env.config.error_style = "fancy"
      $env.config.use_ansi_coloring = true
      $env.config.use_kitty_protocol = true

      $env.config.completions.external.enable = true
      $env.config.completions.external.max_results = 200

      $env.config.ls.clickable_links = true
      $env.config.ls.use_ls_colors = true

      $env.config.rm.always_trash = false

      $env.config.table.header_on_separator = false
      $env.config.table.index_mode = "always"
      $env.config.table.mode = "rounded"
      $env.config.table.show_empty = true
      $env.config.table.trim.methodology = "wrapping"
      $env.config.table.trim.wrapping_try_keep_words = true
      $env.config.table.trim.truncating_suffix = "..."

      $env.config.shell_integration.osc2 = false
      $env.config.shell_integration.osc7 = true
      $env.config.shell_integration.osc8 = true
      $env.config.shell_integration.osc9_9 = false
      $env.config.shell_integration.osc133 = true
      $env.config.shell_integration.osc633 = true
      $env.config.shell_integration.reset_application_mode = true

      $env.config.hooks.command_not_found = {||}
      $env.config.hooks.env_change = {}
      $env.config.hooks.display_output = {
        tee { table --expand | print }
        | $env.last = $in
      }

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
  };
}
