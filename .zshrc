#!/usr/bin/env zsh

## history settiing
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history       
setopt share_history
setopt hist_verify
setopt hist_ignore_dups
zstyle ':completion:*' history-size $HISTSIZE
zstyle ':completion:*' save-history $SAVEHIST

## color setting
zmodload zsh/complist
export TERM=xterm-256color
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS

## Supplementary candidate color setting
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'
zstyle ':completion::complete:*' use-cache true

## prompt color
autoload -U colors; colors
setopt prompt_subst

fpath+=~/.zsh/zsh-completions
autoload -Uz compinit
compinit

## prompt display setting
function {
  PROMPT="%{${fg[green]}%}%n@%m%{${fg[white]}%}:%{${fg[yellow]}%}%3~%{${fg[white]}%}$%{${reset_color}%} "
  PROMPT2="%{${fg[green]}%}%_%%%{${reset_color}%} "
  SPROMPT="%{${fg[green]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
  RPROMPT='`check_git_status`'
}

## git setting
function check_git_status {
  local name st color

  if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
    return 0
  fi

  name=$(git symbolic-ref HEAD 2> /dev/null | sed 's!refs/heads/!!')

  if [[ -z $name ]]; then
    return 0
  fi

  st=$(git status --short 2> /dev/null)
  case "$st" in
    "") color=${fg[green]} ;;           # Status clean
    *"\?\? "* ) color=${fg[yellow]} ;;  # Untracked
    *"\ M "* ) color=${fg[red]} ;;      # Modified
    * ) color=${fg[cyan]} ;;            # Added to commit
  esac

  echo "[%{$color%}$name%{$reset_color%}]"
}

## Supplementary candidate on
autoload -U compinit promptinit; compinit
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
setopt correct
setopt auto_menu
setopt auto_list
setopt list_packed
setopt list_types
setopt noautoremoveslash
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt auto_param_keys
setopt magic_equal_subst
unsetopt promptcr
setopt nobeep
setopt extended_glob
setopt numeric_glob_sort
setopt print_eight_bit



## enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

## some more ls aliases
alias ls='ls -X --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


bindkey '^I' expand-or-complete
zstyle ':completion:*' menu select

## PATH
export PATH=/usr/bin:/usr/local/bin:/usr/local/sbin:$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

## uv completion
eval "$(uv generate-shell-completion zsh)"

