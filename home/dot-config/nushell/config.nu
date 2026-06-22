$env.config.show_banner = false
$env.PATH ++= [($env.HOME | path join ".local/bin")]

mkdir ($nu.data-dir | path join "vendor/autoload")

# history
mkdir ~/.local/share/atuin/
atuin init nu | save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")

# autocompletions
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")

# terminal line
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# smarter cd with z
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

