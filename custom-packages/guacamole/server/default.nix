{ stdenv
, lib
, fetchFromGitHub
, autoconf
, automake
, gnumake
, pkg-config
, perl
, cairo
, libjpeg # Can be replaced with libjpeg_original
, libpng
, libtool
, libossp_uuid # Can be replaced with libuuid

  # Dependencies for optional features
, ffmpeg # Can be replaced with ffmpeg_full
, freerdp # Can be replaced with freerdp_full
, pango
, libssh2
, libtelnet
, libwebsockets
, libvncserver
, libpulseaudio
, openssl
, libvorbis
, libwebp

  # Optional features
, withGuacenc ? false # Requires FFmpeg, provides support for sessions recording
, withRDP ? false # Requires FreeRDP, provides support for RDP sessions
, withVNC ? false # Requires libvncserver, provides support for VNC sessions
, withPulseAudio ? false # Requires pulseaudio, provides audio support for VNC
, withTelnet ? false # Requires libtelnet & pango, provides support for Telnet sessions
, withSSH ? false # Requires libssh2 & pango & openssl, provides support for SSH sessions
, withKubernetes ? false # Requires libwebsockets & pango & openssl, provides support for Kubernetes
, withSSL ? true # Requires openssl, provides SSL support for communication with the client & required for Kubernetes & SSH
, withVorbis ? false # Requires libvorbis, provides vorbis support for audio
, withWebp ? false # Requires libwebp, provides webp support for screenshots
}:

stdenv.mkDerivation rec {
  pname = "guacamole-server";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "apache";
    repo = pname;
    rev = version;
    sha256 = "sha256-028XsWOGEXDIkC8hXnum/liNqmwiJsxANL1v/z/2194=";
  };

  preConfigure = ''
    autoreconf -fi
  '';

  nativeBuildInputs = [ libtool autoconf automake gnumake pkg-config perl ];

  buildInputs = [
    cairo
    libjpeg
    libpng
    libtool
    libossp_uuid
  ]
  ++ lib.optional withGuacenc ffmpeg.dev
  ++ lib.optional withRDP (lib.getDev freerdp)
  ++ lib.optional withVNC libvncserver
  ++ lib.optional (withPulseAudio && withVNC) libpulseaudio
  ++ lib.optional (withSSH || withTelnet || withKubernetes) pango.dev
  ++ lib.optional withTelnet libtelnet
  ++ lib.optional withSSH libssh2
  ++ lib.optional withKubernetes libwebsockets
  ++ lib.optional (withSSL || withSSH || withKubernetes) openssl.dev
  ++ lib.optional withWebp libwebp
  ++ lib.optional withVorbis libvorbis;
}
