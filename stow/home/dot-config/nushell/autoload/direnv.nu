# directory-level environment variables
use std/config *

$env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD? | default []) + [{||
  if (which direnv | is-empty) {
    return
  }

  direnv export json | from json | default {} | load-env

  # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
  $env.PATH = do (env-conversions).path.from_string $env.PATH
}]

