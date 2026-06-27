# automatically enter nix projects
$env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD? | default []) + [
  {
    |before, after|
    let flake = ($after | path join "flake.nix")

    if ($flake | path exists) and ($env.IN_NIX_SHELL? | is-empty) {
      if $env.__CURRENT_FLAKE != $after {
        $env.__CURRENT_FLAKE = $after
        ^nix develop
      }
    } else if $env.__CURRENT_FLAKE != null {
      hide-env __CURRENT_FLAKE
    }
  }
]

