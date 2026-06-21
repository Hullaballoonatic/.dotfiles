{
  description = "Casey's Linux systems and packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    codex-nix.url = "github:SecBear/codex-nix";
    noctalia.url = "github:noctalia-dev/noctalia/legacy-v4";
    vicinae.url = "github:vicinaehq/vicinae";
    zen-browser.url = "github:youwen5/zen-browser-flake";
  };

  outputs = inputs@{ nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    hostname = "desktop";
    username = "casey";
  in {
    packages.${system}.core = pkgs.buildEnv {
      name = "core";
      paths =
        (import ./packages/core.nix { inherit pkgs inputs; })
        ++
        (with pkgs; [
          topgrade
        ]);
    };

    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs hostname username;
      };
      modules = [
        ./hosts/${hostname}/configuration.nix
      ];
    };

    formatter.${system} = pkgs.alejandra;
  };
}
