$env.config.show_banner = false
$env.EDITOR = 'nvim'

# starship (terminal line)
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

