{ lib, pkgs, ... }:

{
  config.programs.helix.languages.language-server = {
    emmet-lsp = {
      command = lib.getExe pkgs.emmet-ls;
      args = [ "--stdio" ];
    };
    gopls = {
      command = lib.getExe pkgs.gopls;
      config = {
        gofumpt = true;
      };
    };
    nixd = {
      command = lib.getExe pkgs.nixd;
      config.nixd = {
        formatting.command = "nixfmt";
        options = {
          nixpkgs.expr = "import <nixpkgs> {}";
        };
      };
    };
    typescript-language-server = {
      command = lib.getExe pkgs.nodePackages.typescript-language-server;
      args = [ "--stdio" ];
    };
  };

  config.programs.helix.languages.language =
    let
      denoFormatter = language: {
        command = "deno";
        args = [
          "fmt"
          "-"
          "--ext"
          language
        ];
      };
      denoLanguages =
        map
          (name: {
            inherit name;
            auto-format = true;
            formatter = denoFormatter name;
          })
          [
            "html"
            "css"
            "scss"
            "json"
            "yaml"
            "markdown"
          ];
    in
    [
      {
        name = "typescript";
        auto-format = true;
        formatter = denoFormatter "ts";
        language-servers = [
          "eslint"
          "typescript-language-server"
        ];
      }
      {
        name = "tsx";
        auto-format = true;
        formatter = denoFormatter "tsx";
        language-servers = [
          "eslint"
          "emmet-lsp"
          "typescript-language-server"
        ];
      }
      {
        name = "javascript";
        auto-format = true;
        formatter = denoFormatter "js";
        language-servers = [
          "eslint"
          "typescript-language-server"
        ];
      }
      {
        name = "jsx";
        auto-format = true;
        formatter = denoFormatter "jsx";
        language-servers = [
          "eslint"
          "emmet-lsp"
          "typescript-language-server"
        ];
      }
      {
        name = "nix";
        auto-format = true;
        formatter.command = "nixfmt";
        language-servers = [
          "nil"
          "nixd"
        ];
      }
      {
        name = "go";
        auto-format = true;
        formatter.command = "gofumpt";
        language-servers = [ "gopls" ];
      }
      {
        name = "python";
        auto-format = true;
        formatter = {
          command = "ruff";
          args = [
            "format"
            "--line-length"
            "88"
            "-"
          ];
        };
        language-servers = [
          "pyright"
          "ruff"
        ];
      }
      {
        name = "kdl";
        formatter = {
          command = "kdlfmt";
          args = [
            "format"
            "-"
          ];
        };
        file-types = [ "kdl" ];
        comment-token = "//";
        indent = {
          tab-width = 2;
          unit = "  ";
        };
      }
    ]
    ++ denoLanguages;
}
