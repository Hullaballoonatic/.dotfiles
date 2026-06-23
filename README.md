
# Using manage

`manage` is a script for bootstrapping, applying, and updating the configurations

`manage bootstrap`
  ├── install platform packages
  ├── install/update Nix
  ├── install Nix profile
  └── apply dotfiles

`manage apply`
  ├── remove conflicting symlinks
  └── stow --adopt

`manage update`
  ├── nix flake update (NixOS)
  └── topgrade (other platforms)
