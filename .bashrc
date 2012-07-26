#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# ============== Environment ====================

export EDITOR="vim"
export VISUAL="vim"



# ============== History =========================
# Keep 1000 lines in .bash_history (default is 500)
export HISTSIZE=10000

# ignore commands that lead with a space, ignore dups
export HISTCONTROL=ignoreboth,ignoredups
shopt -s histappend

#Write continuously
export PROMPT_COMMAND='history -a'

# ============= Utilities ========================

# Get size of directory
dirsize() {
     sudo find . ! -name . -type d -prune -exec du -hs {} \;
}

# Easy extract
extract () {
       if [ -f $1 ] ; then
          case $1 in
               *.tar.bz2)   tar xvjf $1    ;;
               *.tar.gz)    tar xvzf $1    ;;
               *.bz2)       bunzip2 $1     ;;
               *.rar)       rar x $1       ;;
               *.gz)        gunzip $1      ;;
               *.tar)       tar xvf $1     ;;
               *.tbz2)      tar xvjf $1    ;;
               *.tgz)       tar xvzf $1    ;;
               *.zip)       unzip $1       ;;
               *.Z)         uncompress $1  ;;
               *.7z)        7z x $1        ;;
               *)           echo "don't know how to extract '$1'..." ;;
          esac
       else
          echo "'$1' is not a valid file!"
       fi
}

# Makes directory then moves into it
function mkcdr {
     mkdir -p -v $1
     cd $1
}

# Creates an archive from given directory
mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

function open {
     if command -v nautilus &> /dev/null; then
          nautilus $1
     fi
}

function shot
{
     scrot '%T_$wx$h_scrot.png' -c -d 5 -e 'mv $f /home/handy/data/.pics/.shots'
}

function prev
{
     COMMAND=`cat ~/.bash_history | grep -v "prev" | grep -v "search_history" | grep $1 | tail -1`
     echo $COMMAND
     eval $COMMAND
     #`search_history $1 | tail -1`
}

# =============== Alias Shortcuts =================
alias home=~/
alias Downloads=~/Downloads
alias workbench=~/workbench

# =============== Alias Command Shortcuts =========

alias lsize='ls --sort=size -lhr' # list by size
alias ff='sudo find / -name $1'
alias search_history='cat ~/.bash_history | grep -v "search_history" | grep $1'
