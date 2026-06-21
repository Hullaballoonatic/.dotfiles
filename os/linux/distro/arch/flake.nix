{
  description = "Casey's packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    codex-nix.url = "github:SecBear/codex-nix";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    linuxRoot = ../..;
  in {
    packages.${system}.core = pkgs.buildEnv {
      name = "core";

      paths = 
        (import "${linuxRoot}/packages/core.nix" { inherit pkgs inputs; })
        ++
        (with pkgs; [
          topgrade
        ]);
    };
  };
}

