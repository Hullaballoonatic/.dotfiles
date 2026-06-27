{
  description = "Rust development shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = builtins.currentSystem;
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          rustc
          cargo
          cargo-edit
          cargo-watch
          rust-analyzer
          clippy
          rustfmt
          pkg-config
          openssl
        ];

        RUST_BACKTRACE = "1"; # panics become less opaque
      };
    };
}

