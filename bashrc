# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

export TERM="screen-256color"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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

# some more ls aliases
alias ll='ls -alrth'
alias la='ls -A'
alias l='ls -CF'

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### Go
export PATH="/home/bpeck/Programs/go/go_appengine:$PATH"
export PATH=$PATH:/usr/local/go/bin

alias c='clear'

# vim!
export EDITOR=vim
export PDF_VIEWER=evince

source ~/dotfiles/notes/note.sh

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}
 
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}
 
export PS1='\[\]\w\[\e[0m\] $(__git_ps1 "[\[\e[0;32m\]%s\[\e[0m\]\[\e[1;33m\]$(parse_git_dirty)\[\e[0m\]]")\$ \[\e[0m\]'

alias gd='git diff --color'
alias gst='git status'

# Function to make reveal slides with pandoc
panrev() {
	~/.cabal/bin/pandoc -t revealjs -s $1.md -o $1.html --slide-level 2 -V revealjs-url:../reveal.js --css ../slides.css
}

# Function to make beamer slides with pandoc, and notes for pdfpc
panbeam() {
	~/.cabal/bin/pandoc -t beamer -o $1.pdf $1.md --slide-level 2 -V theme:Berlin -V colortheme:beaver

	# Track current slide number, and whether we are viewing a comment
	let slide=1
	let comment=0
	file=$1.pdfpc
	echo "[file]" > $file
	echo "$1.pdf" >> $file
	echo "[notes]" >> $file

	# Loop through every line in input
	while read p; do
		# If in a comment, check exit. Else, print comment for note
        	if [ $comment -eq 1 ] ;
        	then
        	        if [[ $p == "-->" ]] ;
        	        then
        	                let comment=0
        	                continue
        	        fi
        	        echo $p >> $file
        	fi
		# Check for new slide markers - # and >
        	if [[ $p == "# "* ]] || [[ $p == "## "* ]] ;
        	then
        	        let slide=slide+1
        	fi
		# Once we start a comment, print info for pdpfpc
        	if [[ $p == "<!---"* ]] ;
        	then
        	        echo "### $slide" >> $file
        	        let comment=1
        	fi
	done < $1.md
}

# Create beamer handouts with pandoc, no pdfpc notes.
panbeam_hand() {
	~/.cabal/bin/pandoc -t beamer -o $1.pdf $1.md --slide-level 2 -V theme:Berlin -V colortheme:beaver -V handout:handout
}

alias pc='~/.cabal/bin/pandoc'
alias vpn='/opt/cisco/anyconnect/bin/vpn'

dict() {
    def=$(curl -s dict://dict.org/d:"$1")
    echo "$def" | less
}

# Lookup Bible Passage
bible() {

    # Usage information
    bible_usage() {
        echo "Usage: bible: [-b -t -v -f -h -w -l <arg>] passage"
        echo "Use bible -h for help"
    }

    # Help information
    bible_help() {
        echo "Usage: bible [OPTIONS] passage"
        echo "Lookup passage in bible"
        echo ""
        echo "Optional arguments:"
        echo -e "  -b\t\tShow line breaks"
        echo -e "  -t\t\tShow section titles (headings)"
        echo -e "  -v\t\tShow verse numbers"
        echo -e "  -f\t\tShow footnotes"
        echo -e "  -w\t\tGet web version (not plain-text)"
        echo -e "  -l ARG\tSet output characters per line"
        echo -e "  -h\t\tDisplay this message"
    }

    # Base URL
    baseurl="http://www.esvapi.org/v2/rest/passageQuery?key=IP"
    url=$baseurl"&include-short-copyright=false"

    # Default format
    format="&output-format=plain-text"

    # Default linebreaks
    breaks="&include-passage-horizontal-lines=false"
    breaks=$breaks"&include-heading-horizontal-lines=false"

    # Default titles (headings)
    title="&include-headings=false"
    title=$title"&include-subheadings=false"

    # Default verse numbering
    verse="&include-verse-numbers=false"
    verse=$verse"&include-first-verse-numbers=false"

    # Default footnotes
    foot="&include-footnotes=false"

    local OPTIND
    while getopts btvfhwl: opt; do
        case $opt in
        b) # line breaks (----)
            breaks="&include-passage-horizontal-lines=true"
            breaks=$breaks"&include-heading-horizontal-lines=true"
            ;;
        t) # section titles (headings)
            title="&include-headings=true"
            title=$title"&include-subheadings=true"
            ;;
        v) # verse numbers
            verse="&include-verse-numbers=true"
            verse=$verse"&include-first-verse-numbers=true"
            ;;
        f) #
            foot="&include-footnotes=true"
            ;;
        h)
            bible_help
            kill -INT $$
            ;;
        w)
            format=""
            ;;
        l)
            url=$url"&line-length=$OPTARG"
            ;;
        \?)
            bible_usage
            kill -INT $$
            ;;
        esac
    done

    # Extract actual passage
    shift $((OPTIND - 1))
    v=$*
    v2=${v//' '/'+'}

    # Add in options
    url=$url$format$breaks$title$verse$foot
    url=$url"&passage=$v2"

    # Make call
    curl $url
    echo ""
}

# Start matlab.  Needs to fake out awesomewm to get to display
mat() {
    wmname LG3D
    matlab -desktop &
}

# Ruby RVM stuff
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
source ~/.rvm/scripts/rvm
source /etc/bash_completion.d/password-store

### Setup ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

