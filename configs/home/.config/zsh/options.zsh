setopt autocd
setopt hist_ignore_dups
setopt share_history
setopt hist_ignore_space
setopt extended_glob
bindkey -e

HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000

# Prompt
autoload -Uz colors vcs_info && colors
setopt prompt_subst

zstyle ':vcs_info:git:*' formats '%F{magenta} %b%f'
zstyle ':vcs_info:*' enable git

precmd() {
  vcs_info
}

# Ultra-minimal prompt: ~ master ❯
PROMPT=$'%F{blue}%~%f${vcs_info_msg_0_} %(?.%F{green}.%F{red})❯%f '

# Completion
autoload -Uz compinit
compinit -C

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
if [[ -n ${LS_COLORS:-} ]]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{cyan}%d%f'
zstyle ':completion:*:messages' format '%F{yellow}%d%f'
zstyle ':completion:*:warnings' format '%F{red}%d%f'
