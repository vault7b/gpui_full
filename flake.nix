{
	description = "A Proxy tool";

  inputs = {
		rust-overlay.url = "github:oxalica/rust-overlay";
		naersk.url = "github:nix-community/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils , naersk , rust-overlay }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
					inherit system;
					overlays = [ (import rust-overlay) ];
					# config = {
					# 	allowUnfree = true;
					# 	microsoftVisualStudioLicenseAccepted = true;
					# };
				};

				linuxPackages = with pkgs; [
					expat
					fontconfig
					freetype
					freetype.dev
					libxrandr

					alsa-lib
					libxkbcommon
					vulkan-loader
					wayland
					libx11
					libxcursor
					libxi
					libxcb

          libdrm
          libgbm
          libgit2
          libglvnd
          libva
          libxcomposite
          libxdamage
          libxext
          libxfixes
				];

				rustNightlyToolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      in
      {
        devShells.default = pkgs.mkShell.override { stdenv = pkgs.llvmPackages.stdenv; }  {
					buildInputs = linuxPackages;

          nativeBuildInputs = with pkgs; [
						pkg-config
						rustNightlyToolchain
            cmake
            curl
            nodejs_22
            perl
            wasmtime
            fontconfig
            freetype
            glib
            lld
            libx11
            libxcb
            openssl
            protobuf
            sqlite
            wayland
            zlib
            zstd
					];

					LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath linuxPackages;
        };
      }
    );
}
