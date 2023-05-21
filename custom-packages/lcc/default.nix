{ stdenv
, fetchFromGitHub
, lib
}:

let
  targets = [
    #"rcc"
    "lburg"
    "cpp"
    "lcc"
    "bprint"
    "liblcc"
  ];
  copyAllTargets = lib.concatMapStringsSep "\n" (x: "cp $BUILDDIR/${x}/${x} $out/bin/${x}") targets;
in
stdenv.mkDerivation {
  pname = "lcc";
  version = "4.2";
  src = fetchFromGitHub {
    owner = "drh";
    repo = "lcc";
    rev = "3fd0acc0c3087411c0966d725a56be29038c05a9";
    sha256 = "sha256-ijvipPMD+GNy73o2HzwG8fE3xnxXly3ckM6cize7qU8=";
  };

  BUILDDIR = "build";

  preBuildPhase = ''
    mkdir -p build
  '';

  installPhase = ''
    mkdir -p $out/bin
    ls -alR
    ${copyAllTargets}
  '';
}
