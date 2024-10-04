{ ... }:

{
  programs = {
    # Allow external binaries (i.e. Mason LSPs)
    nix-ld.enable = true;
  };
}
