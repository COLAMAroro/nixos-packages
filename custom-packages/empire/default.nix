{ poetry2nix
, python310
, python310Packages
, ruff
, zlib
, lib
, fetchFromGitHub
, powershell
, openssl
, xar
, bomutils
}:

let
  src = fetchFromGitHub {
    owner = "BC-SECURITY";
    repo = "empire";
    rev = "v5.1.2";
    sha256 = "sha256-Y4IdbsC0RCR9QHZE1OkeGRx17E0Fmr3e2BTAMq18Wk0=";
    fetchSubmodules = true;
  };
  _addSetuptools = super: pkg: super."${pkg}".overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [ super.setuptools ];
  });
  _pyRuff = python310.pkgs.toPythonModule ruff;
  _uvicorn = addons: (python310.pkgs.buildPythonPackage rec {
    pname = "uvicorn";
    version = "0.14.0";

    nativeBuildInputs = [
      python310Packages.click
      python310Packages.asgiref
      python310Packages.h11
    ] ++ addons;

    doCheck = false;

    src = python310Packages.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-Ra19+qp9Vcq0zR6F4D8n6dYLwGfdxZ21KisK7KiHApI=";
    };

    patchPhase = ''
      # The setup.py file is trying to install an unspecified version of click
      # ("click>=7.*")
      # And it wrecks havoc with the click package in nixpkgs
      # Let's just set it to the version in nixpkgs
      substituteInPlace setup.py \
        --replace "click>=7.*" "click==${python310Packages.click.version}"
      
    '';
  });
  _pyinstaller = addons: (python310.pkgs.buildPythonPackage rec {
    pname = "pyinstaller";
    version = "5.9.0";

    PYI_STATIC_ZLIB = "1";

    nativeBuildInputs = [
      python310Packages.django
      zlib.dev
    ] ++ addons;

    doCheck = false;

    src = python310Packages.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-K94WqNZk6OupqnuE9yn3qwBcF5O+T+GYazycrWxIZiI=";
    };
  });
  _pyinstaller-hooks-contrib = addons: (python310.pkgs.buildPythonPackage rec {
    pname = "pyinstaller-hooks-contrib";
    version = "2023.2";

    nativeBuildInputs = [
      python310Packages.setuptools
    ] ++ addons;

    doCheck = false;

    src = python310Packages.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-f7hWqB/QanFxiKMXXKp36QIDXMBnsAtYPGQJxiSXsj8=";
    };
  });
in
poetry2nix.mkPoetryApplication rec {
  inherit src;
  projectDir = "${src}";
  python = python310;
  overrides = poetry2nix.defaultPoetryOverrides.extend
    (self: super: rec {
      jq = python310Packages.jq;
      donut-shellcode = _addSetuptools super "donut-shellcode";
      pysecretsocks = _addSetuptools super "pysecretsocks";
      altgraph = _addSetuptools super "altgraph";
      zlib-wrapper = _addSetuptools super "zlib-wrapper";
      macholib = _addSetuptools super "macholib";
      pygame = python310Packages.pygame;
      pyinstaller-hooks-contrib = _pyinstaller-hooks-contrib [ ];
      uvicorn = _uvicorn [ ];
      ruff = _pyRuff;
      stone = python310Packages.stone;
      xlutils = _addSetuptools super "xlutils";
      pyinstaller = _pyinstaller [ altgraph macholib pyinstaller-hooks-contrib ];
      dropbox = python310Packages.dropbox;
    });
  nativeBuildInputs = [
    powershell
    openssl
    xar
    bomutils
    python310Packages.h11
    python310Packages.asgiref
    python310Packages.click
    (_pyinstaller-hooks-contrib [ ])
  ];

  meta = {
    description = "Empire is a post-exploitation agent written in Python that uses the PowerShell Empire framework";
    homepage = "https://github.com/BC-SECURITY/Empire";
    license = lib.licenses.bsd3;
    mainProgram = "empire";
  };
}
