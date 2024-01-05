{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = inputs @ { self, nixpkgs, rust-overlay }: let
    # System types to support.
    supportedSystems =
      [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

    # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    # Nixpkgs instantiated for supported system types.
    nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
  in rec {
    packages = forAllSystems (system: 
      let pkgs = nixpkgsFor.${system}; 
      in rec {
        vidsquash = pkgs.callPackage ./pkg.nix {};
        default = vidsquash;
      }
    );

    devShells = forAllSystems (system:
      let pkgs = nixpkgsFor.${system};
      in rec {
        default = with pkgs; mkShell {
         buildInputs = [
           pkgs.rustPlatform.bindgenHook
           cargo
           # rust.cargo
           # rust.rustc
           # rust.rust-analyzer-wrapped
           rust-analyzer
         ];

         allowUnfree = true;

         LIBCLANG_PATH = "${libclang.lib}/lib";
         FFMPEG_DLL_PATH = "${ffmpeg_6-full.lib}/lib/libavcodec.so";
         FFMPEG_INCLUDE_DIR = "${ffmpeg_6-full.dev}/include";
         shellHook = ''
             zsh
           '';
       };
      }
    );
  };
}
