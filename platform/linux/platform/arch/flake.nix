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
  in {
    packages.${system}.core = pkgs.buildEnv {
      name = "core";

      paths = with pkgs; [
          atuin
          bat
          carapace
          fd
          fzf
          git
          github-cli
          htop
          jq
          ncdu
          neovim
          nushell
          ripgrep
          sesh
          starship
          stow
          tmux
          topgrade
          tree-sitter
          wget
          yazi
          zoxide
          inputs.codex-nix.packages.${pkgs.system}.default
      ];
    };
  };
}
