# XDG Base Directory Setup 
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Configure Zinit paths
declare -A ZINIT
ZINIT[HOME_DIR]="${XDG_DATA_HOME}/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/zinit.git"
ZINIT[ZCOMPDUMP_PATH]="${XDG_CACHE_HOME}/zsh/zcompdump"
ZINIT[MAN_DIR]="${XDG_DATA_HOME}/zinit/man"

# Install Zinit itself
if [[ ! -f "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
    mkdir -p "${ZINIT[HOME_DIR]}"
    git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT[BIN_DIR]}"
fi
source "${ZINIT[BIN_DIR]}/zinit.zsh"

# Completion Settings
autoload -Uz compinit
zicompinit -C # enable cache for faster startup
zinit cdreplay # Replay Turbo mode and load plugins

zstyle :compinstall filename '$HOME/.config/zsh/.zshrc'
# Case-insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Enable menu-style completion (arrows to choose)
zstyle ':completion:*' menu select
# Group completions by type
zstyle ':completion:*' group-name ''

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit wait lucid for \
     zsh-users/zsh-autosuggestions \
     zsh-users/zsh-completions \
     zsh-users/zsh-history-substring-search \
     zsh-users/zsh-syntax-highlighting

# Configure Pure prompt
PURE_CMD_MAX_EXEC_TIME=999999999999999999 # disable execution time display
autoload -U promptinit; promptinit
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

# History Settings
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

setopt incappendhistory sharehistory histignorealldups histfindnodups histignorespace histnofunctions

# General options
setopt autocd 
setopt extendedglob
setopt correct # auto-correct small typos

# Enable vi keybindings
bindkey -v
bindkey -M viins '^F' autosuggest-accept

# Enable fzf
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -AlFh'
alias vim='nvim'
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Display a random pokemon if run in interactive mode
#if [[ -o interactive ]]; then
#    pokeget --hide-name random
#fi
