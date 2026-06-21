{
  description = "Casey's NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    noctalia.url = "github:noctalia-dev/noctalia/legacy-v4";
    vicinae.url = "github:vicinaehq/vicinae";
    zen-browser.url = "github:youwen5/zen-browser-flake";
    codex-nix.url = "github:SecBear/codex-nix";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      hostname = "desktop";
      username = "casey";
      lib = nixpkgs.lib;
    in {
      nixosConfigurations.${hostname} = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs hostname username;
          linuxRoot = ../..;
        };
        modules = [
          ./hosts/${hostname}/configuration.nix
        ];
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    };
}

