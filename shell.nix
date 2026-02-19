{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
        gnumake
        libllvm
        pkg-config
        glib
        glibc
        meson
        ninja
        cmake
        emscripten
        python314
        binaryen
        git
        bash
        autoconf
        unzip
        zip
        javaPackages.compiler.openjdk25
        alsa-lib
        alsa-oss
        cups
        fontconfig
        xorg.libX11
        xorg.libXinerama
        xorg.libXext
        xorg.libXcursor
        xorg.libXtst
        xorg.libXt
        xorg.libXinerama
        xorg.libXext
        xorg.libXcursor
        xorg.libXrender
        xorg.libXrandr
        xorg.xorgproto
    ];
}