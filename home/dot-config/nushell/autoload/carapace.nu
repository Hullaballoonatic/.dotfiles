# completion

# optional
# $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

# custom global cache
if ($nu.cache-dir | find | is-empty) {
    print "generating carapace cache"
    mkdir $"($nu.cache-dir)"
    carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu" | do { clear }
}

source ~/.cache/carapace/init.nu

