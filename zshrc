######################
# Intro
######################

# If this is not an interactive session then we don't need to run all this
# In fact, running this could be a problem.
# For scp and the like

if [[ ! $- =~ "i" ]]
then
    return
fi

function col_echo {
    tput setaf $2
    echo $1
    tput sgr0

}
col_echo "Running ~/.zshrc ..." 3

col_echo "Not in Emacs" 5
PROMPT="%{$(tput setaf 236; tput setab 141)%}%1~:%n%{$(tput sgr0; tput setaf 141)%} %{$(tput sgr0)%}"

######################
# Shell  Settings
######################

# brew shellenv
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

# Update env variables
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:~/.cargo/bin
export PATH=$PATH:~/.rustup/toolchains/nightly-x86_64-apple-darwin/bin
export CXX=clang++
export CC=clang

# Setup local install
export PATH="/Users/russell/installed_software/bin:$PATH"
export LD_LIBRARY_PATH="/Users/russell/installed_software/lib:$PATH"

# What's this for again?
export EMAIL_ADDRESS='russell.w.bentley@icloud.com'

# Why do we have this again?
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

#######################
# Aliases / One Liners
#######################

# escalate priviledges
alias e='sudo zsh'

# git aliases
alias gdi='git diff --no-index'
alias gis='git status'
alias gid='git diff | tee /dev/tty | pbcopy'
alias gist='git status && git diff | tee /dev/tty | pbcopy'
alias gim='git commit -a -m'
alias gip='git pull'
alias gitlog='git log --graph'
alias removeUntrackedFiles='sudo git ls-files --others --exclude-standard | xargs rm -rf'
alias fixSubmodules='git submodule update --init --recursive'
alias git-clang-form="git status | \
rg '\W+(modified|new file):\W+([a-zA-Z./]+)' -r '$2' | \
rg '\.(cpp|h)$' | \
xargs clang-format -i --style=file"

# Cargo Aliases
alias ctl='cargo test --color always -- --nocapture 2>&1 | less'
alias cbl='cargo build --color always 2>&1 | less'
function cel {
    cargo run --release --color always --example $1 2>&1 | less
}

# less always needs color~
alias less='less -R'

# Info / Inspect aliases
alias ip="ifconfig | rg 'inet\s+(\d{3}\.\d{3}\.\d\.\d{3})' -o -r '\$1'"
alias i="echo \"host: $(hostname)\"; echo \"ip: `ip`\"; echo \"CPU Cores: `/usr/sbin/sysctl -n hw.ncpu`\""
alias spacereport="du -h -d 2 . | sort -k 1 -h | less"

# exa aliases
alias ls='exa --all'
alias ll='exa --all --long --header'
alias lll='exa --long --header --color=always | less -R'
alias tree='exa --long --tree -I .git'
alias mtreel='exa --tree -I .git --color=always | less -R'
alias treel='exa --long --tree -I .git --color=always | less -R'

# NeoVim aliases
alias view='nvim -R'
alias vim='nvim'
alias tvim='nvim term://zsh'

# misc aliases
alias fd='fd --hidden'
alias alert='echo "\a"'
alias fixSubmodules='git submodule update --init --recursive'
alias runSketch='processing-java --sketch=$(pwd) --output=$(pwd)/output --force --run'

# this one gets passed a list of filenames, will return <linecount>\t<filename>
alias len="xargs -n 1 perl -lne 'END { print \"\$.\t\$ARGV\"; }'"

######################
# Functions
######################
col_echo "Functions..." 4
function colors {
    for i in $(seq 0 255)
    do
        tput setaf $i
        echo "Color: $i"
        tput sgr0
    done
}

# edit function makes it easier to change settings
function edit {
    case $1 in
    zsh)
        nvim ~/.zshrc
        source ~/.zshrc
        ;;
    git)
        nvim ~/.gitconfig
        ;;
    tmux)
        nvim ~/.tmux.conf
        tmux source-file ~/.tmux.conf
        ;;
    nvim)
        nvim ~/.config/nvim/init.vim
        ;;
    alacritty)
	nvim ~/.config/alacritty/alacritty.yml
	;;
    *)
        echo "$1 is not in edit ..."
        ;;
    esac
}

# tmux aliases
alias tmls='tmux ls'
alias tmks='tmux kill-server'

# Use to attach to tmux sessions, so that ssh forwarding is enabled
# Note that we only want this behaivor when on an ssh connection
function tmat {
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
    then
        tmux attach-session -t $1 \; new-window 'source ~/.ssh/latestagent'
    else
        tmux attach-session -t $1
    fi
}

# Knowledge Poor Man's C++ type finder
# Usage: findType <Type>
function findType {
  rg "(struct|class|trait|enum|using)\W*$1"
}

# Run clang-format-10 on all new or modified .cpp or .h files in dir
function formatChanges {
    git status | \
    rg '\W+(modified|new file):\W+([a-zA-Z./]+)' -r '$2' | \
    rg '\.(cpp|h)$' | \
    xargs clang-format -i --style=file
}

function format {
    find core test test/inc cli -name '*.cpp' -or -name '*.h' | \
    xargs clang-format-10 -i --style=file
}

# Page colored ripgrep output
function rgl {
    rg $1 --color=always --heading --line-number | less
}

######################
# Done
######################
col_echo "Done ..." 3