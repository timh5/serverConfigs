#!/bin/sh
#Add this line to ~/.bash_profile
#TDIR=/path/to/this/dir
#[ -f $TDIR/.bash_profile ] && source $TDIR/.bash_profile

MYDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


## For Gnu Screen, display hostname in window title
if [ "$PS1" ]; then
  if [ -z "$PROMPT_COMMAND" ]; then
    case $TERM in
    screen*)
      #if [ -e /etc/sysconfig/bash-prompt-screen ]; then
      #    PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
      #else
          #PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
          #PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}"'
          PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME}"'
      #fi
      ;;
    esac
  fi
fi



# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace


#Git auto completions
source $MYDIR/.git-completion.sh
source $MYDIR/misc/z.sh


#alias t='todo -d /root/svn.tim/todo/todo.cfg'

#grep
alias grep='grep --colour'
alias egrep='egrep --colour'
alias grepr='egrep * -R --colour --exclude="*svn*" -e '
alias greps='egrep --colour --exclude="*svn*" '
alias vi="$MYDIR/bin/vi"


#git stuff
alias gits='git status'
alias gita='git add'
alias gdiff='git diff'
alias gdif='git diff'



#misc
alias ll='ls -l'
alias duh='du -h --max-depth=1'
alias duhk='du -h --max-depth=1|grep -vE "^[0-9.]{1,3}K"'

## du with human readable but sorted
alias duff='du -sk * | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done'

alias tailp='tail -f /var/log/php.log'

alias psa='ps aux | grep'

## svn update
alias svnstu='svn st -u | grep -v ^?'
alias svnst='svn st | grep -v ^?'

PATH=$PATH:$MYDIR/bin
export PATH


function wtitle {
	NEWTITLE=$1
	[ "$NEWTITLE" == "" ] && NEWTITLE=`hostname`;
    if [ "$TERM" == "xterm" ] ; then
    # Remove the old title string in the PS1, if one is already set.
    #PS1=`echo $PS1 | sed -r 's/^\\\\\[.+\\\\\]//g'`
    export PS1="\[\033]0;$NEWTITLE - \w\007\]$PS1 "
    else
    echo "You are not working in xterm. I cannot set the title."
    fi
}

export PS1="[`hostname|sed -r 's/(www.|.com)//g'`:\W]"
wtitle


