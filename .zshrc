# {{{ ZSH Modules
autoload -U compinit zmv zshzle
compinit -D    
autoload colors && colors   
# }}}

PATH=$PATH:$HOME/.rvm/bin:/opt/android-sdk/tools
PROMPT="%{$fg[green]%}[%~] %{$reset_color%}%(#.%{$fg_bold[red]%}.%{$fg[green]%})%n%{$reset_color%}%{$fg[green]%}@%m%{$reset_color%}%(?.%{$fg_bold[green]%}.%{$bg[red]%}%{$fg_bold[white]%}) >%{$reset_color%} "

# {{{ Export variables
export TERM='rxvt-unicode'
export EDITOR='emacs -nw'
export PAGER='most'
export LC_ALL='ru_RU.UTF-8'
export LANG='ru_RU.UTF-8'
export LC_CTYPE=C
export BLOCKSIZE='Mb'
export GREP_COLOR='1;33'
export LESSCHARSET='UTF-8'
export LESS_TERMCAP_mb=$'\E[01;31m'       
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  
export LESS_TERMCAP_me=$'\E[0m'           
export LESS_TERMCAP_so=$'\E[38;5;246m'    
export LESS_TERMCAP_se=$'\E[0m'           
export LESS_TERMCAP_us=$'\E[04;38;5;146m' 
export LESS_TERMCAP_ue=$'\E[0m'           
# }}}

# {{{ ZSH Options
setopt PUSHD_TO_HOME
setopt MULTIOS
setopt histexpiredupsfirst histfindnodups
setopt AUTO_CD
setopt SH_WORD_SPLIT
setopt IGNORE_EOF
setopt NO_BEEP
setopt extended_glob
setopt MENUCOMPLETE
setopt nohup
setopt ZLE
setopt MULTIBYTE
setopt NUMERIC_GLOB_SORT
# }}}

# {{{ History stuff
HISTFILE=~/.zsh-history
SAVEHIST=5000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY 
# }}}

# {{{ Functions
# {{{ Misc
function dialogrun; { rm -rf $(dialog --separate-output --checklist file 100 100 100 $(for l in $(ls -A); do echo "$l" "$(test -d $l && echo "dir" || echo "file")" 0; done) --stdout); clear  }
zle -N dialogrun

precmd() {
  [[ -t 1 ]] || return
 case $TERM in
 *xterm*|rxvt|(dt|k|E|a)term*) print -Pn "\e]0;[%~] %n@%m\a" ;;
 screen(-bce|.linux)) print -Pn "\ek[%~]\e\" && print -Pn "\e]0;[%~] %n@%m (screen)\a" ;;  
 esac
}
preexec() {
 [[ -t 1 ]] || return
 case $TERM in
 *xterm*|rxvt|(dt|k|E|a)term*) print -Pn "\e]0;<$1> [%~] %n@%m\a" ;;
 screen(-bce|.linux)) print -Pn "\ek<$1> [%~]\e\" && print -Pn "\e]0;<$1> [%~] %n@%m (screen)\a" ;;
 esac
}
# }}}

# {{{ Command exstensions
typeset -g -A key
ccd() { cd $1 && ls}
rmd(){ local P="`pwd`"; cd .. && rmdir "$P" || cd "$P"; }
rnm() {
    name=$1
    vared -c -p 'Переименовать в: ' name
    command mv $1 $name
}
ccopy(){ cp $1 /tmp/ccopy.$1; }
mkd() { mkdir $1; cd $1 }
# }}}

# {{{ Archivation
unpack() {
if [ -f $1 ] ; then
case $1 in
 *.tar.bz2)   tar xjf $1        ;;
 *.tar.gz)    tar xzf $1     ;;
 *.bz2)       bunzip2 $1       ;;
 *.rar)       unrar x $1     ;;
 *.gz)        gunzip $1     ;;
 *.tar)       tar xf $1        ;;
 *.tbz2)      tar xjf $1      ;;
 *.tgz)       tar xzf $1       ;;
 *.zip)       unzip $1     ;;
 *.Z)         uncompress $1  ;;
 *.7z)        7z x $1    ;;
 *)           echo "$fg_bold[red]Ошибка:$reset_color Невозможно распаковать '$1'..." ;;
esac
else
echo "$fg_bold[red]Ошибка:$reset_color '$1' - неподдерживаемый тип файла"
fi
}

pack() {
if [ $1 ] ; then
case $1 in
 tbz)    tar cjvf $2.tar.bz2 $2      ;;
 tgz)    tar czvf $2.tar.gz  $2    ;;
 tar)   tar cpvf $2.tar  $2       ;;
 bz2) bzip $2 ;;
 gz)  gzip -c -9 -n $2 > $2.gz ;;
 zip)    zip -r $2.zip $2   ;;
 7z)     7z a $2.7z $2    ;;
 *)      echo "$fg_bold[red]Ошибка:$reset_color '$1' не может быть упакован через pack()" ;;
esac
else
echo "$fg_bold[red]Ошибка:$reset_color '$1' - неподдерживаемый тип файла"
fi
}
# }}}
# }}}

# {{{ Aliases
# {{{ Command aliases
alias cpaste="ls /tmp/ccopy.* | sed 's|/tmp/ccopy.||' | xargs -I % mv /tmp/ccopy.% ./%"
alias mv='nocorrect mv'
alias cp='nocorrect cp -R'
alias rm='nocorrect rm'
alias rmrf='nocorrect rm -fR'
alias mkdir='nocorrect mkdir'
alias ls='ls --color=auto'   
alias lsd='ls -ld .*'    
alias lls='ls -alFh --color=auto'
alias grep='grep --color=auto'   
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias df='df -h'
alias du='du -h'
alias psgrep='ps aux | grep $(echo $1 | sed "s/^\(.\)/[\1]/g")'
alias dirtree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'
# }}}

# {{{ Application aliases
alias emcs='emacs -nw'
alias jdeveloper='~/bin/Oracle/Middleware/jdeveloper/jdev/bin/jdev'
alias netbeans='~/bin/netbeans-7.4/bin/netbeans'
# }}}

# {{{ Global aliases
alias -g convKU="| iconv -c -f koi8r -t utf8"  
alias -g convCU="| iconv -c -f cp1251 -t utf8"
alias -g convUK="| iconv -c -f utf8 -t koi8r"  
alias -g convUC="| iconv -c -f utf8 -t cp1251"
# }}}

# {{{ Suffix aliases
if [[ $DISPLAY = '' ]] then
    alias -s {txt,log,list,org,conf,xml,rb,java}="emacs -nw"
    alias -s {ogg,mp3,wav,m3u,pls,flac,cue}="mocp"
else
    alias -s {list,conf,log}="emacs -nw"    
    alias -s {txt,org,xml,rb,java}="nohup emacs"
    alias -s {pdf,djvu}="nohup evince"
    alias -s {avi,mpeg,mpg,mov,m2v,flv}="nohup vlc"
    alias -s {ogg,mp3,wav,m3u,pls,flac,cue}="nohup deadbeef"
    alias -s {jpg,jpeg,png,gif,tif,tiff,bmp}="nohup mirage"
    alias -s {htm,html}="nohup firefox"
fi
# }}}
# }}}

# {{{ Completion
zstyle ':completion:*' menu yes select 
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command' 
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*::::' completer _expand _complete _correct _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*' verbose yes
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format '> %B%d%b'
zstyle ':completion:*:messages' format '> %d'
zstyle ':completion:*:warnings' format '> Ошибка: нет совпадений для: %d'
zstyle ':completion:*:corrections' format '> %B%d (число ошибок: %e)%b'
zstyle ':completion:*:correct:*' insert-unambiguous true
zstyle ':completion:*:correct:*' original true
zstyle ':completion:*:correct:*' prompt 'исправить на:'
zstyle ':completion:*' prompt 'Исправить (число ошибок: %e) > '
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' match-original both
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~''*?.old' '*?.pro'
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:incremental:*' completer _complete _correct
zstyle ':completion:*:predict:*' completer _complete
zstyle ':mime:*' x-browsers firefox rekonq google-chrome konqueror chromium-browser
zstyle ':mime:*' tty-browsers w3m elinks links lynx
zstyle -e ':completion:*' hosts 'reply=($myhosts)'
zstyle ':completion:*' insert-tab true
zstyle ':completion:*' select-prompt '%SСтрока: %LЭлемент: %M[%p]%s'
zstyle ':completion:*' list-prompt '%SТекущее положение: %p%s'
zstyle ':completion:*' sort true
zstyle ':completion:*' file-sort name
zstyle ':completion:*' keep-prefix changed
zstyle ':completion:*:man:*' separate-sections true
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes select
zstyle ':completion:*' old-menu true
zstyle ':completion:*' original true
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' word true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:(ssh|scp|ftp):*' hosts $hosts
zstyle ':completion:*:(ssh|scp|ftp):*' users $users
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
zstyle ':completion:*:*:*:users' ignored-patterns adm apache bin daemon games gdm halt ident junkbust lp mail mailnull named news nfsnobody nobody nscd ntp operator pcap postgres radvd rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs
# }}}

# {{{ Keybindings
bindkey -e # emacs-mode
bindkey "^[^[[D" emacs-backward-word
bindkey "^[^[[C" emacs-forward-word
# }}}
