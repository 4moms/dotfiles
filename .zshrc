test -s ~/.alias && . ~/.alias || true
dict() { curl dict://dict.org/d:$1; }
sdict() { curl dict://dict.org/m:$1; }
wp() { elinks -dump -no-numbering http://en.wikipedia.org/wiki/$1 | less; }
kk() { kill -9 `ps -ef | grep $1 | awk '{print $2}'`; }

function urlopen()
{ 
	open "http://$*" 
}
alias -s com=urlopen

alias x=' history -c && rm -f ~/.zsh_history'

function firefox() { command firefox "$@" & }

function extract()      # Handy Extract Program.
{
       if [ -f $1 ] ; then
         case $1 in
         *.tar.bz2)   tar xvjf $1     ;;
         *.tar.gz)    tar xvzf $1     ;;
         *.bz2)       bunzip2 $1      ;;
         *.rar)       unrar x $1      ;;
         *.gz)        gunzip $1       ;;
         *.tar)       tar xvf $1      ;;
         *.tbz2)      tar xvjf $1     ;;
         *.tgz)       tar xvzf $1     ;;
         *.zip)       unzip $1        ;;
         *.Z)         uncompress $1   ;;
         *.7z)        7z x $1         ;;
         *)           echo "'$1' cannot be extracted via >extract<" ;;
       esac
       else
         echo "'$1' is not a valid file"
       fi
}

autoload colors ; colors
local blue_op="%{$fg[yellow]%}[%{$reset_color%}"
local blue_cp="%{$fg[yellow]%}]%{$reset_color%}"
local path_p="${blue_op}%~${blue_cp}"
local user_host="${blue_op}%n@%m${blue_cp}"
local ret_status="${blue_op}%?${blue_cp}"
local hist_no="${blue_op}%h${blue_cp}"
local smiley="%(?,%{$fg[green]%}(=%{$reset_color%},%{$fg[red]%}X(%{$reset_color%})"
PROMPT="╭─${path_p}─${user_host}─${blue_op}%D{%H:%M} %D{%a %b %d}${blue_cp}─${ret_status}─${hist_no}
╰─${blue_op}%B%F${smiley}%b%f${blue_cp} %# "
local cur_cmd="${blue_op}%_${blue_cp}"
PROMPT2="${cur_cmd}> "
