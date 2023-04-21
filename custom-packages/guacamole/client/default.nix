{ stdenvNoCC
, fetchFromGitHub
, buildMaven
, maven
, javaPackages
}:

let
  repo = (buildMaven ./project-info.json).repo;
  mavenPlugins = [
    javaPackages.mavenPlugins.mavenEnforcer_1_3_1
    javaPackages.junit_3_8_2
  ];
  mavenPluginsPaths = plug:
    if builtins.isList plug
    then builtins.concatStringsSep ":" (builtins.map mavenPluginsPaths plug)
    else "${plug}";
  allPlugins = builtins.concatStringsSep ":" (builtins.map mavenPluginsPaths mavenPlugins);
in
stdenvNoCC.mkDerivation rec {
  pname = "guacamole-client";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "apache";
    repo = pname;
    rev = version;
    sha256 = "sha256-b9hcZEQfENp4BGLey9S0T4ASMDbk7+Rlu8n/xjZVtvY=";
  };

  nativeBuildInputs = [
    maven
    javaPackages.mavenPlugins.mavenEnforcer_1_3_1
    javaPackages.junit_3_8_2
  ];

  buildPhase = ''
    # Build the war file, use offline repository
    mvn --offline -Dmaven.repo.local=${repo}:${allPlugins} package;
  '';

  installPhase = ''
    mkdir -p $out/share/java
    cp guacamole/target/guacamole-${version}.war $out/share/java/guacamole.war
  '';
}
