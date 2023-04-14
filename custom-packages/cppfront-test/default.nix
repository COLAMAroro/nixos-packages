{ stdenv
, lib
, cppfront
}:

stdenv.mkDerivation {
  pname = "cppfront-test";
  src = ./.;

  buildInputs = [ cppfront ];

  buildPhase = ''
    cppfront test.cpp2
    $CXX -std=c++20 -o cppfront-test test.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp cppfront-test $out/bin
  '';

  meta.mainProgram = "cppfront-test";
  meta.license = lib.licenses.wtfpl;
  # No upstream, this derivation is self contained.
  # And you can Whatever The Fuck You Want with it.
}
