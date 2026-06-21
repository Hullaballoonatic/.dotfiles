$env.config.show_banner = false

# history
mkdir ~/.local/share/atuin/
atuin init nu | save -f ~/.local/share/atuin/init.nu

# autocompletions
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
mkdir $"($nu.cache-dir)"
carapace _carapace nushell | save -f $"($nu.cache-dir)/carapace.nu"

# terminal line
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# smarter cd with z
zoxide init nushell | save -f ~/.zoxide.nu

