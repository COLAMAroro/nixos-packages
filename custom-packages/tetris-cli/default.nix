{ stdenv
, lib
, fetchFromGitHub
, ncurses
}:

stdenv.mkDerivation {
  name = "tetris-cli";
  src = fetchFromGitHub {
    owner = "S1M0N38";
    repo = "tetris";
    rev = "feb98b531cda49f622bd6ebe257303da2ba49a18";
    sha256 = "sha256-O7cXFdG3fv0tvGwj+/oXc6cP67MW4HCui14b5HlOXGo=";
  };

  buildInputs = [ ncurses ];

  patchPhase = ''
    cp ${./Makefile} Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp tetris $out/bin
  '';

  meta = {
    description = "A simple terminal tetris video_game";
    homepage = "https://github.com/S1M0N38/tetris";
    license = lib.licenses.mit;
    mainProgram = "tetris";
  };
}
