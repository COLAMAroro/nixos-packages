{ buildBazelPackage
, lib
, fetchFromGitHub
, python39
, bazel
}:

buildBazelPackage {
  inherit bazel;
  pname = "carbon";
  version = "unstable-2023-04-13";

  src = fetchFromGitHub {
    owner = "carbon-language";
    repo = "carbon-lang";
    rev = "1f49c3e36d67e66f039df6b1bee9a07f556ed2ac";
    fetchSubmodules = true;
    sha256 = "sha256-9PpA71iTOWeK8C/oDP9GrGFYoJzsLNyVowtry2Io91E=";
  };

  bazelTargets = [
    "//:toolchain"
    "//:bazel/cc_toolchain"
    "//:explorer"
  ];
  buildInputs = [ python39 ];
  buildAttrs = { };
  fetchAttrs.sha256.x86_64-linux = lib.fakeSha256;
}
