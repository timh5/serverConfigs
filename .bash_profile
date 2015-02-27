#!/bin/sh
#Add this line to ~/.bash_profile
#[ -f /opt/vyew/.bash_profile ] && source /opt/vyew/.bash_profile

#Git auto completions
source /opt/vyew/.git-completion.sh
source /opt/vyew/misc/z.sh

#vz shortcuts
alias vzc='vzctl enter'
alias vzl='vzlist -o veid,hostname,kmemsize,kmemsize.l,privvmpages,physpages,numtcpsock,numflock,numfile'

#alias t='todo -d /root/svn.tim/todo/todo.cfg'

#grep
alias grep='grep --colour'
alias egrep='egrep --colour'
alias grepr='egrep * -R --colour --exclude="*svn*" -e '
alias greps='egrep --colour --exclude="*svn*" '

#git stuff
alias gits='git status'
alias gita='git add'
alias gdiff='git diff'
alias gdif='git diff'



#misc
alias ll='ls -l'
alias tp='tail -f /var/log/php.log'
alias tps='tail -f /var/log/vyew/secLog.log'
alias tailp='tail -f /var/log/php.log'
alias duh='du -h --max-depth=1'
alias duhk='du -h --max-depth=1|grep -vE "^[0-9.]{1,3}K"'

## du with human readable but sorted
alias duff='du -sk * | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done'

alias tailp='tail -f /var/log/php.log'

alias psa='ps aux | grep'

## svn update
alias svnstu='svn st -u | grep -v ^?'
alias svnst='svn st | grep -v ^?'

PATH=$PATH:/opt/vyew/bin:/opt/vyew/mysql.utils
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


