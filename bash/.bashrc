# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes # terminal not recognized

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

source ~/.git-prompt.sh

__check_if_in_ssh(){
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    return 1
  else
    return 0
  fi
}

__command_prompt(){
  local LAST_STATUS="$?"
  local JOBS_COUNT=$(jobs -s | wc -l)

  local DATE=$'\[\033[01;37m\][\D{%F %T}]'
  local BRANCH=$'\[\033[01;36m\]$(__git_ps1 "%s:")'
  local EXIT_STATUS=''
  if [ $LAST_STATUS -eq 0 ]; then
      # \u2b55 is circle character (maru)
      EXIT_STATUS=$'\[\033[01;32m\]\u2713 '
  else
      EXIT_STATUS=$'\[\033[01;31m\]\u2718 \u2794 \[\033[01;31m\]'
      EXIT_STATUS+="$LAST_STATUS"
  fi
  local DEBIAN_CHROOT=$'\[\033[01;00m\]:${debian_chroot:+($debian_chroot)}'
  local USER_HOST=''
  if __check_if_in_ssh; then
      USER_HOST=$'\[\033[01;32m\]\u@\h\[\033[00m\]:'
  else
      USER_HOST=$'\[\033[01;31m\]\u@\h\[\033[00m\]:'
  fi
  local WORKING_DIR=$'\[\033[01;35m\]\w'
  local JOBS=''
  if [ $JOBS_COUNT -ne 0 ]; then
      JOBS=$'\[\033[01;36m\]'
      JOBS+="(j: $JOBS_COUNT)"
  fi
  local PROMPT=$'\[\033[00m\]\[$(randhsv)\]\u2764 \[\033[00m\]'
  PS1="\n"
  PS1+="$DATE"
  PS1+=" "
  PS1+="$BRANCH"
  PS1+="$EXIT_STATUS"
  PS1+="$DEBIAN_CHROOT"
  PS1+="$USER_HOST"
  PS1+="$WORKING_DIR"
  PS1+=" "
  PS1+="$JOBS"
  PS1+="\n"
  PS1+="$PROMPT"
}

if [ "$color_prompt" = yes ]; then
    PROMPT_COMMAND=__command_prompt
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# to generate basic color database for ls:
#   $ dircolors -p > ~/.dircolors
# change ~/.dircolors to get different colors for 'ls'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export EDITOR="nvim"

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# provisional aliases for https://github.com/ogham/exa
alias ell='exa -lhmF --time-style long-iso --git -@'
alias ela='exa -lhmF --time-style long-iso --git -@ -a'
alias ellt='exa -lhmF --time-style long-iso --git -@ -T'
alias elat='exa -lhmF --time-style long-iso --git -@ -a -T'
alias el='exa -F'
alias ea='exa -aF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# fix colors
if [[ -z $TMUX ]]; then
    # fixes dark blue to cornflower blue in terminal, other color: 166ECC
    printf %b '\e]4;4;#0E3EC4\a' # works in st and xterm

    # Fixes colors in tmux on xterm - tmux needs to know that underlying
    # terminal supports 256 colors. Not needed in st terminal.
    if [[ $TERM == "xterm" ]]; then
        TERM=xterm-256color
    fi
fi

# exit should detach if on tmux, rather than kill a pane
exit() {
    if [[ -z $TMUX ]]; then
        builtin exit
    else
        tmux detach
    fi
}

# C-d (EOF) should not close a terminal (repeat 5 times if you really want it)
export IGNOREEOF=50

# added by fzf for fuzzy search
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# fzf should also search through hidden files
export FZF_DEFAULT_COMMAND='rg -l -g "!.git/" --hidden ""'

# always use neovim
alias vim=nvim
alias vv=nvim

# allow 'watch' to recognize aliases
alias watch='watch '

# workaround for tig highlight line problem (linked with $TERM and ncurses)
alias aptitude='sudo TERM=screen-256color aptitude'
alias htop='sudo TERM=screen-256color htop'
alias mocp='TERM=screen-256color mocp'
alias tig='TERM=screen-256color tig'
alias weechat='TERM=screen-256color weechat'

# launch nvim with files from fzf
vimf() {
  local files;
  IFS=$'\n' files=($(fzf $@))
  if [ $? -eq 0 ]; then
    nvim "${files[@]}"
    for file in "${files[@]}"
    do
      echo "$file"
    done
  fi
}

# favourite directory switcher with fzf
. ~/Scripts/ff

# directory switcher with fzf
cdd() {
  cd $(find . -type d | fzf)
}

###### workaround for delete key in nvim in st (and some other things probably)
__st_workaround() {
	tput rmkx
}

tput smkx

trap __st_workaround EXIT
###### workaround end

# test true-color in tmux/st
# printf "\x1b[38;2;210;100;80mTRUECOLOR\x1b[0m\n"

# map capslock to ctrl (run only once?)
#setxkbmap -option ctrl:nocaps

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Additional configuration per host
if [ -e ~/.bashrc_$(hostname) ]; then
  . ~/.bashrc_$(hostname)
fi
