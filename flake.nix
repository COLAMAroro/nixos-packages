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
        mainOrDefault = pkg: pkg.mainProgram or pkg.pname or pkg.name;
        mkApp = pkg: {
          type = "app";
          program = "${pkg}/bin/${self.lib.mainOrDefault pkg}";
        };
      };
      packages.x86_64-linux = {
        binary-ninja = nixpkgs.legacyPackages.x86_64-linux.qt6Packages.callPackage ./custom-packages/binary-ninja { };
        pulsar = nixpkgs.legacyPackages.x86_64-linux.callPackage ./custom-packages/pulsar { };
        pulsar-french = self.packages.x86_64-linux.pulsar.override {
          languages = [
            "en_US"
            "fr-moderne"
          ];
        };
        tetris-cli = nixpkgs.legacyPackages.x86_64-linux.callPackage ./custom-packages/tetris-cli { };
        empire = nixpkgs.legacyPackages.x86_64-linux.callPackage ./custom-packages/empire { };
        cppfront = nixpkgs.legacyPackages.x86_64-linux.callPackage ./custom-packages/cppfront { };
        cppfront-test = nixpkgs.legacyPackages.x86_64-linux.callPackage ./custom-packages/cppfront-test { cppfront = self.packages.x86_64-linux.cppfront; };
      };
      apps.x86_64-linux = rec {
        binary-ninja = self.lib.mkApp self.packages.x86_64-linux.binary-ninja;
        binja = binary-ninja;
        pulsar = self.lib.mkApp self.packages.x86_64-linux.pulsar;
        tetris-cli = self.lib.mkApp self.packages.x86_64-linux.tetris-cli;
        empire = self.lib.mkApp self.packages.x86_64-linux.empire;
        cppfront = self.lib.mkApp self.packages.x86_64-linux.cppfront;
        cppfront-test = self.lib.mkApp self.packages.x86_64-linux.cppfront-test;
      };
    };
}
