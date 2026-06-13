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
        ripgrep
        fd
        jq
        bat
        wget
        htop
        ncdu
        fzf
        zoxide
        atuin
        starship
        carapace
        git
        github-cli
        stow
        tmux
        yazi
        nushell
        neovim
        topgrade
        tree-sitter
        nodejs
      ];
    };
  };
}
