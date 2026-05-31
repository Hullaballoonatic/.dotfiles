$env.config.show_banner = false
$env.EDITOR = 'nvim'

# starship (terminal line)
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# nix path config. don't know why this does not work in autoload...
$env.PATH = (
  $env.PATH
  | prepend $"($env.HOME)/.nix-profile/bin"
  | prepend "/nix/var/nix/profiles/default/bin"
  | uniq
)

