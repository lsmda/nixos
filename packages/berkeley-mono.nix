{ config, pkgs, ... }:

let
  berkeley-mono = pkgs.stdenv.mkDerivation rec {
    name = "berkeley-mono";

    src = ../secrets/assets/berkeley-mono.zip;
    ageKeyFile = /home/${config.machine.username}/.config/sops/age/keys.txt;

    nativeBuildInputs = [
      pkgs.sops
      pkgs.unzip
    ];

    unpackPhase = ''
      echo "Skipping default unpack phase"
    '';

    buildPhase = ''
      echo "Copying age key file..."
      tmpdir=$(mktemp -d)
      cp ${ageKeyFile} "$tmpdir/age-key.txt"

      echo "Decrypting the zip file..."
      export SOPS_AGE_KEY_FILE=$tmpdir/age-key.txt
      sops -d $src > berkeley-mono.zip
      echo "Decryption successful."

      echo "Unzipping the decrypted fonts..."
      unzip berkeley-mono.zip
      rm -rf "$tmpdir"
    '';

    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -r berkeley-mono/*.otf $out/share/fonts/opentype/
    '';

    meta = {
      description = "Berkeley Mono typeface family";
      longDescription = ''
        Berkeley Mono is a monospace typeface family with 20 fonts
        including Thin, ExtraLight, Light, SemiLight, Regular, Medium,
        SemiBold, Bold, ExtraBold, and Black weights, each with oblique variants.
      '';
    };
  };
in

{
  config = {
    fonts.packages = [ berkeley-mono ];
  };
}
