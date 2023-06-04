{ pkgs ? import <nixpkgs> { } }:
let
  pypkgs = pkgs.python39Packages;

  pycryptodomex = pypkgs.buildPythonPackage rec {
    pname = "pycryptodomex";
    version = "3.18.0";
    src = pypkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-Pj7LX+l558G7ACflGDQKz37mBBXXkpXlJR0Txo3eV24=";
    };
    doCheck = false;
  };

  gpsoauth = pypkgs.buildPythonPackage rec {
    pname = "gpsoauth";
    version = "1.0.2";
    format = "wheel";
    src = pypkgs.fetchPypi {
      inherit pname version format;
      sha256 = "sha256-jxlbXzDfMQmnnmyNRfK9RcD+ZN/velq8AzvGUI+WGr8=";
      python = "py3";
      dist = "py3";
      platform = "any";
    };
    doCheck = false;
    propagatedBuildInputs = [ pycryptodomex pypkgs.requests ];
  };

  mock = pypkgs.buildPythonPackage rec {
    pname = "mock";
    version = "5.0.2";
    src = pkgs.fetchFromGitHub {
      owner = "testing-cabal";
      repo = "mock";
      rev = "5.0.2";
      sha256 = "sha256-8zTDgGdz6T1qSuzpn1SfhadR6dA0r+BQiiZOBO+TQc4=";
    };
    doCheck = false;
  };

  future = pypkgs.buildPythonPackage rec {
    pname = "future";
    version = "0.18.3";
    src = pypkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-NKF0Nu0elml6hvnePRWjsL4B2LyN6cHf/Vn7gjTtUwc=";
    };
    doCheck = false;
  };

  gkeepapi = pypkgs.buildPythonPackage rec {
    pname = "gkeepapi";
    version = "0.14.2";
    format = "wheel";
    src = pypkgs.fetchPypi {
      inherit pname version format;
      sha256 = "sha256-D8yNaRGNGjh1Sl+941wW1E7Vu4IamK5islQTZ21MN7E=";
      python = "py2.py3";
      dist = "py2.py3";
      platform = "any";
    };
    doCheck = false;
    propagatedBuildInputs = [ gpsoauth mock future ];
  };

  deps = _: [
    gkeepapi
  ];
in
(pkgs.python39.withPackages deps).env
