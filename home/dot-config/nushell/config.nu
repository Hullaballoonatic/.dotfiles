$env.config.show_banner = false
$env.EDITOR = $"(which nvim | get path.0)" # won't be necessary for nixOS

mkdir ($nu.data-dir | path join "vendor/autoload")

# history
atuin init nu | save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")

# autocompletions
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")

# terminal line
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# smarter cd with z
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

$env.PATH = (
  $env.PATH
  | prepend ($env.HOME | path join "/.nix-profile/bin")
  | prepend "/nix/var/nix/profiles/default/bin"
  | uniq
)

