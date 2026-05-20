# java sdk version manager
$env.path ++= [($env.HOME | path join ".sdkman" "candidates" "java" "current" "bin")]

def --env sdk [...args: string] {
  run-bash 'source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk "$@"' ...$args
}

def --env run-bash [script: string, ...args: string] {
  ^bash -lc $script bash ...$args
}

