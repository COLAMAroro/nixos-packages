{ stdenv
, lib
, glib
, libglvnd
, xorg
, fontconfig
, dbus
, autoPatchelfHook
, requireFile
, unzip
, wayland
, wrapQtAppsHook
, qt6
, zlib
}:

stdenv.mkDerivation rec {
  name = "BinaryNinja-personal";
  version = "3.3.3996";

  src = requireFile {
    name = "BinaryNinja-personal-3.3.3996.zip";
    sha256 = "0riirycbbw3ri3lkh6zwcx3rq8snvvr4z99zi852j0zs6f7r0291";
    message = ''
      Binary Ninja is not free software, and I cannot redistribute it.
      Get a download link with your licenced email at https://binary.ninja/recover/
      Rename your file to ${name}-${version}.zip and put it in the nix store via
      nix-prefetch-url file://$PWD/${name}-${version}.zip
    '';
  };

  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r binaryninja/* $out/bin

    mkdir -p $out/share/applications
    cat > $out/share/applications/binaryninja.desktop << EOF
    [Desktop Entry]
    Name=Binary Ninja
    Exec=$out/bin/binaryninja
    Icon=$out/bin/docs/img/logo.png
    Type=Application
    Categories=Development;
    EOF
  '';

  dontWrapQtApps = true;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    stdenv.cc.cc
    glib # libglib-2.0.so.0
    fontconfig # libfontconfig.so.1
    dbus # libdbus-1.so.3
    libglvnd # libGL.so.1
    xorg.libX11 # libX11.so.6
    xorg.libXi # libXi.so.6
    xorg.libXrender # libXrender.so.1
    wayland # libwayland.so.0
    qt6.qtbase # Everything Qt6
    zlib # libz.so.1
    stdenv.cc.cc.lib # libstdc++.so.6
    qt6.qtdeclarative # libQt6Qml.so.6 
    qt6.qtwayland # libQt6WaylandClient.so.6
  ];

  meta = with lib; {
    description = "Binary Ninja is an interactive decompiler, disassembler, debugger, and binary analysis platform built by reverse engineers, for reverse engineers.";
    longDescription = "Binary Ninja is an interactive decompiler, disassembler, debugger, and binary analysis platform built by reverse engineers, for reverse engineers. Developed with a focus on delivering a high-quality API for automation and a clean and usable GUI, Binary Ninja is in active use by malware analysts, vulnerability researchers, and software developers worldwide.";
    homepage = "https://binary.ninja/";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
  };
}
