$env.PYENV_ROOT = "~/.pyenv" | path expand

$env.path ++= [
  ($env.PYENV_ROOT | path join "bin"),
  ($env.PYENV_ROOT | path join "shims"),
]

