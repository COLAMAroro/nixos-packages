{
  description = "All of my custom packages, in a shiny overlay";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self
    , nixpkgs
    , ...
    }@inputs:
    {
      overlays.default = import ./custom-packages;
      lib = {
        mkApp = pkg: {
          type = "app";
          program = nixpkgs.lib.getExe pkg;
        };
      };
      packages.x86_64-linux = let pkgs = nixpkgs.legacyPackages.x86_64-linux; in
        {
          binary-ninja = pkgs.qt6Packages.callPackage ./custom-packages/binary-ninja { };
          pulsar = pkgs.callPackage ./custom-packages/pulsar { };
          pulsar-french = self.packages.x86_64-linux.pulsar.override {
            languages = [
              "en_US"
              "fr-moderne"
            ];
          };
          tetris-cli = pkgs.callPackage ./custom-packages/tetris-cli { };
          empire = pkgs.callPackage ./custom-packages/empire { };
          cppfront = pkgs.callPackage ./custom-packages/cppfront { };
          cppfront-test = pkgs.callPackage ./custom-packages/cppfront-test { cppfront = self.packages.x86_64-linux.cppfront; };
          carbon = pkgs.callPackage ./custom-packages/carbon { };
          wclip = pkgs.callPackage ./custom-packages/wclip { };
          guacamole.server = pkgs.callPackage ./custom-packages/guacamole/server {
            withGuacenc = true;
            withRDP = true;
            withVNC = true;
            withPulseAudio = true;
            withTelnet = true;
            withSSH = true;
            withKubernetes = true;
            withSSL = true;
            withVorbis = true;
            withWebp = true;
          };
          guacamole.client = pkgs.callPackage ./custom-packages/guacamole/client { };
          lcc = pkgs.callPackage ./custom-packages/lcc { };
        };
      devShells.x86_64-linux = let pkgs = nixpkgs.legacyPackages.x86_64-linux; in
        {
          python = {
            gkeepapi = (import ./gkeepapi.nix { inherit pkgs; });
          };
        };
    };
}
