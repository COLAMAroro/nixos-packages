{ stdenv
, lib
, fetchFromGitHub
}:

let
  cc-by-nc-nd-40 = {
    deprecated = false;
    free = false;
    fullName = "Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International";
    shortName = "CC-BY-NC-ND-4.0";
    spdxId = "CC-BY-NC-ND-4.0";
    url = "https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode";
  }; # Awaiting a merge on Nixpkgs
in
stdenv.mkDerivation {
  pname = "cppfront";
  version = "unstable-2023-04-07";

  src = fetchFromGitHub {
    owner = "hsutter";
    repo = "cppfront";
    rev = "f83ca9b727e9c07f60a1933584a49a3d971936f5";
    sha256 = "sha256-rPz/06hDpNn2P2COAB//wT46LQXi9vW4CTN47WqzZUM=";
  };

  buildPhase = ''
    $CXX source/cppfront.cpp -std=c++20 -o cppfront
  '';

  installPhase = ''
    mkdir -p $out/bin $out/include
    cp cppfront $out/bin
    cp include/cpp2util.h $out/include
  '';

  meta = {
    homepage = "https://github.com/hsutter/cppfront";
    license = cc-by-nc-nd-40;
  };
}
