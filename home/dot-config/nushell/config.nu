$env.config.show_banner = false
$env.EDITOR = $"(which nvim | get path.0)"

# mkdir ($nu.data-dir | path join "vendor/autoload")

# terminal line
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# smarter cd
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

# source ~/.zoxide.nu

# nix path config. don't know why this does not work in autoload...
$env.PATH = (
  $env.PATH
  | prepend $"($env.HOME)/.nix-profile/bin"
  | prepend "/nix/var/nix/profiles/default/bin"
  | prepend $"($env.HOME)/.local/npm-global/bin"
  | uniq
)

