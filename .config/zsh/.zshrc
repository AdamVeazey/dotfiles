#!/usr/bin/env zsh

# zsh
mkdir -p "$XDG_STATE_HOME/zsh"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000

# Man pages
export MANPAGER='nvim +Man!'


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

# Pure Prompt
PURE_CMD_MAX_EXEC_TIME=999999999999999999 # disable execution time display
zinit ice as"theme"
zinit light sindresorhus/pure

if (( $+commands[dircolors] )); then
	eval "$(dircolors)"
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

zstyle :compinstall filename '${ZDOTDIR}/.zshrc' # Case-insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Enable menu-style completion (arrows to choose)
zstyle ':completion:*' menu select # Group completions by type
zstyle ':completion:*' group-name ''

# Completion Settings
#autoload -Uz compinit
#compinit -d "${ZINIT[ZCOMPDUMP_PATH]}"
#zicompinit -C # enable cache for faster startup
zicompinit -C -d "${ZINIT[ZCOMPDUMP_PATH]}"
zinit cdreplay -q # Replay Turbo mode and load plugins


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
	atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down' \
	zsh-users/zsh-syntax-highlighting

setopt incappendhistory sharehistory histignorealldups histfindnodups histignorespace histnofunctions

# General options
setopt autocd
setopt extendedglob globdots
setopt correct # auto-correct small typos

# Enable vi keybindings
bindkey -v
bindkey -M viins '^F' autosuggest-accept
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down
bindkey -M viins '^[OA' history-substring-search-up
bindkey -M viins '^[OB' history-substring-search-down

# Enable fzf
(( $+commands[fzf] )) && source <(fzf --zsh)
[[ -f "${XDG_CONFIG_HOME}/.aliases" ]] && source "${XDG_CONFIG_HOME}/.aliases"
#(( $+commands[compdef] )) && compdef config=git # tab completions work for config as if it was git

if (( $+functions[prompt_pure_preprompt_render] )); then
	# Use zsh's parameter substitution to find and replace that exact print line
	functions[prompt_pure_preprompt_render]="${functions[prompt_pure_preprompt_render]/print/:}"
fi

# Display a random pokemon if run in interactive mode
#if [[ -o interactive ]]; then
#    pokeget --hide-name random
#fi
