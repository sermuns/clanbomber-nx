{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devkitNix.url = "github:bandithedoge/devkitNix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      devkitNix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # devkitNix provides an overlay with the toolchains
          overlays = [ devkitNix.overlays.default ];
        };
      in
      {
        # devkitNix provides standard environments which set all the necessary variables and add dependencies.
        # No more shell hooks!
        devShells.default =
          pkgs.mkShell.override
            {
              stdenv = pkgs.devkitNix.stdenvA64;
            }
            {
              buildInputs = [
                pkgs.boost
                pkgs.boost.dev
                pkgs.SDL
                pkgs.SDL_image
                pkgs.SDL_mixer
                pkgs.SDL_ttf
                pkgs.SDL_gfx
                pkgs.pkg-config
              ];

              shellHook = ''
                export BOOST_ROOT=${pkgs.boost.dev}
                export BOOST_INCLUDEDIR=${pkgs.boost.dev}/include
                export BOOST_LIBRARYDIR=${pkgs.boost.out}/lib
                export PKG_CONFIG_PATH=${pkgs.SDL}/lib/pkgconfig:$PKG_CONFIG_PATH
                export LDFLAGS="-L${pkgs.SDL_image}/lib -L${pkgs.SDL_mixer}/lib -L${pkgs.SDL_ttf}/lib -L${pkgs.SDL_gfx}/lib $LDFLAGS"
                export SDL_CFLAGS="$(sdl-config --cflags)"
                export SDL_LIBS="$(sdl-config --libs)"
              '';
            };

        packages.default = pkgs.stdenv.mkDerivation {
          name = "devkitA64-example";
          src = ./.;

          # The `TARGET` variable is used by devkitPro's example Makefiles to set the name of the executable.
          makeFlags = [ "TARGET=example" ];
          # This is a simple Switch app example that only builds a single
          # executable. If your project outputs multiple files, make `$out` a
          # directory and copy everything there.
          installPhase = ''
            mkdir $out
            cp example.nro $out
          '';
        };

      }
    );
}
