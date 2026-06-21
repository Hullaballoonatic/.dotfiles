{ pkgs, inputs }:

with pkgs; [
  # bootstrap
  git
  stow # config applier

  # terminal
  atuin # history
  bat # cat replacement
  carapace # autocompletions
  fd # find replacement
  fzf # fuzzy finding
  gh # github cli and authentiaction
  htop # system monitor
  jq # json querying
  ncdu # disk usage viewer
  neovim # editor
  nushell # shell
  ripgrep # better grep
  sesh # tmux session manager
  starship # line
  tmux # multiplexer
  tree-sitter # dependency for many cool things
  yazi # file explorer
  zoxide # cd replacement

  # utilities
  udiskie

  # LSPs
  stylua
  lua-language-server
  rust-analyzer
  pyright
  typescript-language-server
  nixd

  # gui apps
  scrcpy # control android phone 
  vesktop # discord but not shit

  # flakes
  inputs.codex-nix.packages.${pkgs.stdenv.hostPlatform.system}.default # openai's terminal agentic ai
]

