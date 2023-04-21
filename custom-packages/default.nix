final: prev: rec {
  # Inspired by https://github.com/Mic92/nur-packages/blob/master/pkgs/binary-ninja/default.nix
  binary-ninja = final.qt6Packages.callPackage ./binary-ninja { };
  #pulsar = final.callPackage ./pulsar { };
  # Pulsar has been included in nixpkgs ! Now let's rename to not conflict with the nixpkgs version
  pulsar-self = final.callPackage ./pulsar { };
  tetris-cli = final.callPackage ./tetris-cli { };
  empire = final.callPackage ./empire { };
  cppfront = final.callPackage ./cppfront { };
  cppfront-test = final.callPackage ./cppfront-test { inherit cppfront; };
  carbon = final.callPackage ./carbon { };
  wclip = final.callPackage ./wclip { };
}
