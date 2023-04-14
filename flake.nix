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
        rec {
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
        };
      apps.x86_64-linux = rec {
        binary-ninja = self.lib.mkApp self.packages.x86_64-linux.binary-ninja;
        binja = binary-ninja;
        pulsar = self.lib.mkApp self.packages.x86_64-linux.pulsar;
        tetris-cli = self.lib.mkApp self.packages.x86_64-linux.tetris-cli;
        empire = self.lib.mkApp self.packages.x86_64-linux.empire;
        cppfront = self.lib.mkApp self.packages.x86_64-linux.cppfront;
        cppfront-test = self.lib.mkApp self.packages.x86_64-linux.cppfront-test;
        carbon = self.lib.mkApp self.packages.x86_64-linux.carbon;
      };
    };
}
