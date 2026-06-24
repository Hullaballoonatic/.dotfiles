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
      lib = nixpkgs.lib;
      username = "casey";

      hosts = {
        desktop = {
          system = "x86_64-linux";
        };

        pi = {
          system = "aarch64-linux";
        };
      };

      pkgsFor = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      mkSystem = hostname:
        let
          host = hosts.${hostname};
        in
          lib.nixosSystem {
            system = host.system;

            specialArgs = {
              inherit inputs hostname username;
            };

            modules = [
              ./hosts/${hostname}/configuration.nix
            ];
          };
    in {
      nixosConfigurations =
        lib.mapAttrs (hostname: _: mkSystem hostname) hosts;

      formatter =
        lib.mapAttrs (_: host: (pkgsFor host.system).alejandra) hosts;

      templates = {
        rust = {
          path = ./templates/rust;
          description = "Rust development environment";
        };
        python = {
          path = ./templates/python;
          description = "Python development environment";
        };
        web = {
          path = ./templates/web;
          description = "Web development environment";
        };
      };
    };
}

