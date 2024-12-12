if [[ -f"${HOME}/.profile" ]]; then
	source "${HOME}/.profile"
fi

# Package Manager
ZINIT_HOME="$HOME/.zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting

# Snippets
zinit snippet OMZP::git
zinit snippet OMZP::kubectl

autoload -Uz compinit && compinit

zinit cdreplay -q

# Completion Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# lsd
alias ls='lsd'

# brew
export PATH=/opt/homebrew/bin:$PATH

# Bun
# bun completions
[ -s "/Users/CaseyStratton/.bun/_bun" ] && source "/Users/CaseyStratton/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Google SDK
# Load Angular CLI autocompletion.
# source <(ng completion script)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/CaseyStratton/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/CaseyStratton/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/CaseyStratton/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/CaseyStratton/google-cloud-sdk/completion.zsh.inc'; fi

# Zoxide
eval "$(zoxide init zsh --cmd cd)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# env vars
export JBHUNT_USERNAME=jisacs4
export JBHUNT_PASSWORD=1BigSpicyBurrito

eval "nvm use stable"
