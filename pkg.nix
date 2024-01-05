{ lib, fetchFromGitHub, rustPlatform, ffmpeg_6-full, libclang, stdenv }:
rustPlatform.buildRustPackage {
  pname = "vidsquash";
  version = "0.0.1";

  buildType = "debug";

  src = ./.;
  cargoHash = "sha256-nN0Gymuiw5yi5tTJn1VWwWDKhvpDIANP7qBkSI/sEUs=";

  nativeBuildInputs = [ libclang libclang.dev rustPlatform.bindgenHook];
  buildInputs = [ ffmpeg_6-full libclang ];

  LIBCLANG_PATH = "${libclang.lib}/lib";
  FFMPEG_DLL_PATH = "${ffmpeg_6-full.lib}/lib/libavcodec.so";
  FFMPEG_INCLUDE_DIR = "${ffmpeg_6-full.dev}/include";
  # FFMPEG_PKG_CONFIG_PATH = 

}
