
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ----------------------------- utility functions ----------------------------
_have()      { type "$1" &>/dev/null; }
_source_if() { [[ -r "$1" ]] && source "$1"; }

# --------------------------- Start tmux on startup --------------------------

# if tmux is executable and not inside a tmux session, then try to attach.
# if attachment fails, start a new session
#[ -x "$(command -v tmux)" ] \
#  && [ -z "${TMUX}" ] \
#  && { tmux attach || tmux; } >/dev/null 2>&1

# --------------------------- environment variables --------------------------
#                           (also see envx)


# Folders
export USER="tim"
export GITUSER="qwertimer"
export DESKTOP="$HOME/Desktop"
export DOCUMENTS="$HOME/Documents"
export DOWNLOADS="$HOME/Downloads"
export PICTURES="$HOME/Pictures"
export MUSIC="$HOME/Music"
export VIDEOS="$HOME/Videos"
export GHREPOS="$HOME/repos/github.com/$GITUSER"
export DOTFILES="$GHREPOS/.dotfiles"
#export ZETDIR="$GHREPOS/zet"
export SNIPPETS="$DOTFILES/snippets"
export TASKS="$DOTFILES/tasks"
export SCRIPTS="$HOME/.local/bin/scripts"
export PYTHONSCRIPTS="$HOME/.local/bin/scripts/python"
export GOSCRIPTS="$HOME/.local/bin/scripts/GO"
export DTSCRIPTS="$HOME/.local/bin/scripts/dt"


export PDFS="$DOCUMENTS/PDFS"
export WORKSPACES="$HOME/Workspaces" # container home dirs for mounting
## rwxrob clip program..... 
export CLIP_DIR="$VIDEOS/Clips"
export CLIP_DATA="$GHREPOS/cmd-clip/data"
export CLIP_VOLUME=0

# terminal stuff
export TERM=xterm-256color
export HRULEWIDTH=80

# Editors
export EDITOR=vim
export VISUAL=vim
export EDITOR_PREFIX=vim

#browser defaults
export HELP_BROWSER=lynx

#grep
#export GREP_OPTIONS=' — color=auto'

# ------------------------ programmming env variables ------------------------
export PYTHONDONTWRITEBYTECODE=1

test -d ~/.vim/spell && export VIMSPELL=(~/.vim/spell/*.add)

export GOPRIVATE="github.com/$GITUSER/*,gitlab.com/$GITUSER/*"
export GOPATH=~/.local/share/go
export GOBIN=~/.local/bin
export GOPROXY=direct
export CGO_ENABLED=0

#rpi pico
export PICO_SDK_PATH=$HOME/Documents/pico/pico/pico-sdk
export PICO_EXAMPLES_PATH=$HOME/Documents/pico/pico/pico-examples
export PICO_EXTRAS_PATH=$HOME/Documents/pico/pico/pico-extras
export PICO_PLAYGROUND_PATH=$HOME/Documents/pico/pico/pico-playground
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"


source /etc/profile.d/bash_completion.sh
alias vi=vim
# ---------------------------------- history ---------------------------------
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
set -o vi


# ---------------------------- bash shell options ----------------------------

shopt -s checkwinsize
#shopt -s expand_aliases
shopt -s globstar
shopt -s dotglob
shopt -s extglob
#shopt -s nullglob # bug kills completion for some
#set -o noclobber
shopt -s histappend


# ----------------------------------- pager ----------------------------------

if test -x /usr/bin/lesspipe; then
      export LESSOPEN="| /usr/bin/lesspipe %s";
        export LESSCLOSE="/usr/bin/lesspipe %s %s";
fi


export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
export GROFF_NO_SGR=1         # For Konsole and Gnome-terminal

# --------------------------------- dircolors --------------------------------

if (command -v dircolors) &>/dev/null; then
  if test -r ~/.dircolors; then
      eval "$(dircolors -b ~/.dircolors)"
  else
      eval "$(dircolors -b)"
  fi
fi


# --------------------------- smart prompt ---------------------------

PROMPT_LONG=20
PROMPT_MAX=95
PROMPT_AT=@
docker_ps1() {
:
}

COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"

git_color() {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_OCHRE
  fi
}

git_branch() {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch)"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit)"
  fi
}

PS1=$USER

git_ps1() {
    #PS1="\[$COLOR_WHITE\]\n[\W]"          # basename of pwd
    PS1+="\[\$(git_color)\]"        # colors git status
    PS1+="\$(git_branch)"           #<prints current branch
    #PS1+="\[$COLOR_BLUE\]\$\[$COLOR_RESET\] "   # '#' for root, else '$'
}


docker_check() {

  #Check if in docker container PS1

  if test -f "$DOCKER"; then
    docker="<docker>"
    echo "$docker"
  fi

}


virtual_env_t() {

  #Check if in venv PS1
  if test -n "$VIRTUAL_ENV"; then
    venv="${VIRTUAL_ENV##*/}"
    echo "$venv"
  else
    venv=""
    echo "$venv"
  fi
}

virtual_env_ps1() {
    PS1+="\[$COLOR_GREEN\][\W]"
    PS1+="\$(virtual_env_t)"
}
docker_ps1() {

    PS1+="\[$COLOR_OCHRE\]"
    PS1+="\$(docker_check)"
}
directory_check() {

  #Check for root
  [[ $EUID == 0 ]] && P='#' && y=$r && p=$y # root
  #If dir is root then show /
  [[ $PWD = / ]] && dir=/ #&& echo "$dir"
  #if dir is home show ~
  [[ $PWD = "$HOME" ]] && dir='~' #&& echo "$dir"

}

directory_ps1() {
    PS1+="\$(directory_check)"

}

__hostname() {
  c="$COLOR_OCHRE" 
  PS1+="$c\h:"
}

__user() {
  c="$COLOR_BLUE"
  PS1+="$c\u@"

}

__owner() {
  c="$COLOR_WHITE"
  reset="$COLOR_RESET"
  PS1+="$c\$$reset"

  
}
__ps1() {
    PS1=
    __user 
    __hostname
    directory_ps1
    virtual_env_ps1
    docker_ps1
    git_ps1
    __owner
}



# ANSI color escape sequences. Useful else, not just the prompt.
C_Red='\e[2;31m';       C_BRed='\e[1;31m';      C_Green='\e[2;32m';
C_BGreen='\e[1;32m';    C_Yellow='\e[2;33m';    C_BYellow='\e[1;33m';
C_Grey='\e[2;37m';      C_Reset='\e[0m';        C_BPink='\e[1;35m';
C_Italic='\e[3m';       C_Blue='\e[2;34m';      C_BBlue='\e[1;34m';
C_Pink='\e[2;35m';      C_Cyan='\e[2;36m';      C_BCyan='\e[1;36m'

# Values '1' or '2' are valid, for new and old versions, respectively.
PROMPT_STYLE=2

PROMPT_PARSER(){
	if [ $PROMPT_STYLE -eq 1 ]; then
		if git rev-parse --is-inside-work-tree &> /dev/null; then
			local Status=`git status -s`
			if [ -n "$Status" ]; then
				local StatusColor=$C_BRed
			else
				local StatusColor=$C_BGreen
			fi

			local Top=`git rev-parse --show-toplevel`
			read Line < "$Top"/.git/HEAD
			local Branch="$C_Italic$StatusColor${Line##*/}$C_Reset "
		fi

		if [ $1 -gt 0 ]; then
			local Exit="$C_BRed🗴$C_Reset"
		else
			local Exit="$C_BGreen🗸$C_Reset"
		fi

		local Basename=${PWD##*/}
		local Dirname=${PWD%/*}

		if [ "$Dirname/$Basename" == '/' ]; then
			CWD="$C_Italic$C_BGreen/$C_Reset"
		else
			CWD="$C_Grey$Dirname/$C_Italic$Basename$C_Reset"

			# If the CWD is too long, just show basename with '.../' prepended, if
			# it's valid to do so. I think ANSI escape sequences are being counted
			# in its length, causing it not work as it should, but I like the
			# result, none-the-less.
			local Slashes=${CWD//[!\/]/}
			TempColumns=$((COLUMNS + 20)) # <-- Seems to work around sequences.
			if ((${#CWD} > (TempColumns - ${#Branch}) - 2)); then
				if [ ${#Slashes} -ge 2 ]; then
					CWD="$C_Grey.../$C_Reset$C_BGreen$Basename$C_Reset"
				else
					CWD=$C_BGreen$Basename$C_Reset
				fi
			fi
		fi

		PS1="$Exit $Branch$CWD\n: "

		unset Line
	elif [ $PROMPT_STYLE -eq 2 ]; then
		X=$1
		(( $X == 0 )) && X=

		if git rev-parse --is-inside-work-tree &> /dev/null; then
			GI=(
				'≎' # Clean
				'≍' # Uncommitted changes
				'≭' # Unstaged changes
				'≺' # New file(s)
				'⊀' # Removed file(s)
				'≔' # Initial commit
				'∾' # Branch is ahead
				'⮂' # Fix conflicts
				'!' # Unknown (ERROR)
				'-' # Removed file(s)
			)

			Status=`git status 2> /dev/null`
			Top=`git rev-parse --show-toplevel`

			local GitDir=`git rev-parse --git-dir`
			if [ "$GitDir" == '.' ] || [ "$GitDir" == "${PWD%%/.git/*}/.git" ]; then
				Desc="${C_BRed}∷  ${C_Grey}Looking under the hood..."
			else
				if [ -n "$Top" ]; then
					# Get the current branch name.
					IFS='/' read -a A < "$Top/.git/HEAD"
					local GB=${A[${#A[@]}-1]}
				fi

				# The following is in a very specific order of priority.
				if [ -z "$(git rev-parse --branches)" ]; then
					Desc="${C_BCyan}${GI[5]}  ${C_Grey}Branch '${GB:-?}' awaits its initial commit."
				else
					while read -ra Line; do
						if [ "${Line[0]}${Line[1]}${Line[2]}" == '(fixconflictsand' ]; then
							Desc="${C_BCyan}${GI[7]}  ${C_Grey}Branch '${GB:-?}' has conflict(s)."
							break
						elif [ "${Line[0]}${Line[1]}" == 'Untrackedfiles:' ]; then
							NFTTL=0
							while read -a Line; do
								[ "${Line[0]}" == '??' ] && let NFTTL++
							done <<< "$(git status --short)"

							printf -v NFTTL "%'d" $NFTTL

							Desc="${C_BCyan}${GI[3]}  ${C_Grey}Branch '${GB:-?}' has $NFTTL new file(s)."
							break
						elif [ "${Line[0]}" == 'deleted:' ]; then
							Desc="${C_BCyan}${GI[9]}  ${C_Grey}Branch '${GB:-?}' detects removed file(s)."
							break
						elif [ "${Line[0]}" == 'modified:' ]; then
							readarray Buffer <<< "$(git --no-pager diff --name-only)"
							printf -v ModifiedFiles "%'d" ${#Buffer[@]}
							Desc="${C_BCyan}${GI[2]}  ${C_Grey}Branch '${GB:-?}' has $ModifiedFiles modified file(s)."
							break
						elif [ "${Line[0]}${Line[1]}${Line[2]}${Line[3]}" == 'Changestobecommitted:' ]; then
							Desc="${C_BCyan}${GI[1]}  ${C_Grey}Branch '${GB:-?}' has changes to commit."
							break
						elif [ "${Line[0]}${Line[1]}${Line[3]}" == 'Yourbranchahead' ]; then
							printf -v TTLCommits "%'d" "${Line[7]}"
							Desc="${C_BCyan}${GI[6]}  ${C_Grey}Branch '${GB:-?}' leads by $TTLCommits commit(s)."
							break
						elif [ "${Line[0]}${Line[1]}${Line[2]}" == 'nothingtocommit,' ]; then
							printf -v TTLCommits "%'d" "$(git rev-list --count HEAD)"

							Desc="${C_BCyan}${GI[0]}  ${C_Grey}Branch '${GB:-?}' is $TTLCommits commit(s) clean."
							break
						fi
					done <<< "$Status"
				fi
			fi
		fi

		#PS1="\[${C_Reset}\]╭──╼${X}╾──☉  ${Desc}\[${C_Reset}\]\n╰─☉  "

		# 2021-06-13: Temporary block — just experimenting.
		if [ -n "$Desc" ]; then
			if [ -n "$X" ]; then
				PS1="\[${C_Reset}\]${Desc}\[${C_Reset}\]\n\[\e[91m\]${X} \[\e[0m\]\[\e[3;2;37m\]➙ \[\e[0m\] "
			else
				PS1="\[${C_Reset}\]${Desc}\[${C_Reset}\]\n\[\e[3;2;37m\]➙ \[\e[0m\] "
			fi
		else
			if [ -n "$X" ]; then
				PS1="\[${C_Reset}\]\[\e[91m\]${X} \[\e[0m\]\[\e[3;2;37m\]➙ \[\e[0m\] "
			else
				PS1="\[${C_Reset}\]\[\e[2;37m\]➙ \[\e[0m\] "
			fi
		fi

		unset Z Line Desc GI Status Top X GB CWD\
			Buffer ModifiedFiles TTLCommits NFTTL
	fi
}

PROMPT_COMMAND='PROMPT_PARSER $?'



__old_ps1() {



  local DOCKER=/.dockerenv
  local P='$' dir="${PWD##*/}" B countme short long double\
    r='\[\e[31m\]' g='\[\e[30m\]' b='\[\e[34m\]' \
    y='\[\e[33m\]' p='\[\e[35m\]' w='\[\e[37m\]' \
    c='\[\e[36m\]' x='\[\e[0m\]'  gr='\[\e[32m\]' 

  
  #git branch in PS1
  B=$(git branch --show-current 2>/dev/null)
  [[ $dir = "$B" ]] && B=.

  #Check if in docker container PS1

  if test -f "$DOCKER"; then
    docker="<docker>"
  fi

  #Check if in venv PS1
  if test -n "$VIRTUAL_ENV"; then
    venv="${VIRTUAL_ENV##*/}"
  else
    venv=""
  fi

  countme="$doc$venv$USER$PROMPT_AT$(hostname):$dir($B)\$ "

  [[ $B = master || $B = main ]] && b="$r"
  


  test -n "$venv" && venv="$c($c$venv$c)"
  [[ -n "$B" ]] && B="$gr($c$B$gr)"
  doc=$gr$docker
  AT="$b$PROMPT_AT"
  dir="$w$dir"
  long_t="$gr╔ "
  double_pl="$gr║ "
  long_b="$gr╚ "
  sym="$p$P"

  short="$y\u$doc$venv$AT$h\h$g:$dir$B$sym$x "
  long="$long_t$y\u$doc$venv$AT$h\h$g:$dir$B\n$long_b$sym$x "
  double="$long_t$y\u$doc$venv$AT$h\h$g:$dir\n$double_pl$B\n$long_b$p$P$x "

  if (( ${#countme} > PROMPT_MAX )); then
    PS1="$double"
  elif (( ${#countme} > PROMPT_LONG )); then
    PS1="$long"
  else
    PS1="$short"
  fi
}

#PROMPT_COMMAND="__ps1"
# ------------------------- Path add/remove functions ------------------------

pathappend() {
  for ARG in "$@"; do
    test -d "${ARG}" || continue
    PATH=${PATH//:${ARG}:/:}
    PATH=${PATH/#${ARG}:/}
    PATH=${PATH/%:${ARG}/}
    export PATH="${PATH:+"${PATH}:"}${ARG}"
  done
}

pathprepend() {
  for ARG in "$@"; do
    test -d "${ARG}" || continue
    PATH=${PATH//:${ARG}:/:}
    PATH=${PATH/#${ARG}:/}
    PATH=${PATH/%:${ARG}/}
    export PATH="${ARG}${PATH:+":${PATH}"}"
  done
}



pathremove() {
    declare arg
    for arg in "$@"; do
        test -d "${arg}" || continue
        PATH=${PATH//:${arg}:/:}
        PATH=${PATH/#${arg}:/}
        PATH=${PATH/%:${arg}/}
        export PATH="${PATH}"
    done
}
export SCRIPTS=~/.local/bin/scripts
mkdir -p "$SCRIPTS" &>/dev/null

export PATH=$GOPATH/bin:$GOROOT/bin:$PATH 


pathprepend \
  ~/.local/bin \
  "$SCRIPTS" \
  "$PYTHONSCRIPTS" \
  "$DTSCRIPTS" \
  "$GOSCRIPTS" \
  ~/.poetry/bin

pathappend \
      /usr/local/opt/coreutils/libexec/gnubin \
      /mingw64/bin \
      /usr/local/bin \
      /usr/local/sbin \
      /usr/games \
      /usr/sbin \
      /usr/bin \
      /snap/bin \
      /sbin \
      /bin

# ---------------------------------- CDPATH ---------------------------------

export CDPATH=.:\
~/repos/github.com:\
~/repos/github.com/$GITUSER:\
~/repos/github.com/$GITUSER/dot:\
~/repos:\
/media/$USER:\
/mnt/SSD:\
~/.local/bin:\
~


# --------------------------------- keyboard ---------------------------------
#makes the caps key escape.
test -n "$DISPLAY" && setxkbmap -option caps:escape &>/dev/null

# -------------------------------- other stuff -------------------------------
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# ------------------------------- source files -------------------------------

#fzf stuff
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -d /usr/share/fzf  ] && source /usr/share/fzf/key-bindings.bash && source /usr/share/fzf/completion.bash

export FZF_DEFAULT_COMMAND='fd . -path './.git' -prune -o -print $HOME'
export FZF_ALT_C_COMMAND="fd -t d . $HOME"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}
#if [ -f ~/.bashrc-personal ]; then
#. ~/.bashrc-personal
#fi
#source "$HOME/.cargo/env"
export PATH="$HOME/gems/bin:$PATH"


## Source all required files in completions folder.
if [ -d ~/.bash_completion.d ]; then
    for file in ~/.bash_completion.d/*; do
        . $file
    done
fi


# -------------------------------- completion --------------------------------

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

# ---------------------------------- theming ---------------------------------

#theme script from https://github.com/lemnos/theme.sh stored in scripts folder
if command -v theme > /dev/null; then
	export THEME_HISTFILE=~/.theme_history
	[ -e "$THEME_HISTFILE" ] && theme "$(theme -l|tail -n1)"

	# Optional

	bind -x '"\x0f":"theme $(theme -l|tail -n2|head -n1)"' #Binds C-o to the previously active theme.
	alias th='theme -i'
	alias thl='theme --light -i'
	alias thd='theme --dark -i'
fi

# --------------------------------- aliases  ---------------------------------

#Make ip have colours
alias ip='ip -br -c'

#locations
alias scripts='cd $SCRIPTS'
alias dot='cd $DOTFILES' 
alias tasks='cd $TASKS'
alias zets='cd ~/.local/share/zet/'
alias whale='cd /mnt/SSD/Masters/Datasets/null'
alias snippets='cd "$SNIPPETS"'

#lynx search
alias ?='duck'
alias ??='google'
alias ???='bing'

#default python
alias python="/usr/bin/python3.9"

#better pip
alias pip="python3 -m pip"

#personal program shortcuts
alias st="taskman listtasks"
alias nt="taskman newtask"
alias ct="taskman closetask"
alias vt="taskman viewtask"
alias ifu="ifuse ~/iphone"

alias pres="cd ~/Work/presentations/docker"

alias walls="cd ~/.local/share/wallhaven"

alias view="vi -R"
alias sshh='sshpass -f $HOME/.sshpass ssh '
alias temp='cd $(mktemp -d)'


alias bat=batcat
#source bash
alias sb=". ~/.bashrc"


#wal='/dev/null << wal -i ~/wallpapers/wallpapers/'
# ------------------------- personalised completions -------------------------

owncomp=(
  pdf md yt gl kn auth pomo config taskman 
  sshkey ws ./build build b ./setup zet ix2me
  venvwrap n netscan
)

for i in ${owncomp[@]}; do complete -C $i $i; done


# ----------------------------------- other ----------------------------------
source "$DOTFILES/snippets/sh/colours"


# -------------------------------- fzf configs -------------------------------
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
'

export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"
export FZF_CTRL_R_OPTS='--sort --exact'

# --------------- personal, work and environment configurations --------------

if [ -f ~/.bashrc_envs ]; then
    . ~/.bashrc_envs
fi

if [[ -f ~/.bashrc_aliases ]]; then
    . ~/.bashrc_aliases
fi


# ---------------------------- Program completions ---------------------------

_have gh && . <(gh completion -s bash)
_have pandoc && . <(pandoc --bash-completion)
_have kubectl && . <(kubectl completion bash)
_have k && complete -o default -F __start_kubectl k
_have kind && . <(kind completion bash)
_have yq && . <(yq shell-completion bash)
_have helm && . <(helm completion bash)
_have minikube && . <(minikube completion bash)
_have mk && complete -o default -F __start_minikube mk
_have docker && _source_if "$HOME/.local/share/docker/completion" # d
_have ansible && _source_if "$HOME/.local/share/ansible/ansible-completion/ansible-completion.bash" 
_have ansible && _source_if "$HOME/.local/share/ansible/ansible-completion/ansible-playbook-completion.bash"


PATH="/home/tim/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/tim/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/tim/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/tim/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/tim/perl5"; export PERL_MM_OPT;
