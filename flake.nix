{
  description = "Casey's packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
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
          jq
          fzf
          git
          github-cli
          htop
          neovim
          ncdu
          nodejs
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
      ];
    };
  };
}
