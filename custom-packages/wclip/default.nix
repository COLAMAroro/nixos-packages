{ stdenv
, fetchFromGitLab
, wayland
}:

stdenv.mkDerivation {
  pname = "wclip";
  version = "1.0.0";

  src = fetchFromGitLab {
    repo = "wclip";
    owner = "j64wang";
    rev = "bf1d938931e639f2aa06cb918d6aadd903eaeeb7";
    sha256 = "sha256-hN0fUs8OH38FlrY4OF4eckA1Ba+ABvdRpKV3YA8PKTs=";
  };

  nativeBuildInputs = [ wayland ];

  buildPhase = ''
    $CC $CFLAGS -o wclip wclip.c -lwayland-client
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp wclip $out/bin
  '';
}

