shopt -s expand_aliases
alias hetzner="ssh -F ~/.ssh/config hetzner"
alias aliases="vim ~/.bash_aliases && source ~/.bashrc"
alias bashrc="vim ~/.bashrc && source ~/.bashrc"
alias inputrc="vim ~/.inputrc && bind -f ~/.inputrc"
alias vimrc="vim ~/.vimrc"
alias ralias="source ~/.bashrc"
# enable color support of ls and also add handy aliases
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias igrep='grep -i --color=auto'
# some more ls aliases
alias lll='ls -AFt1 --color | nl'
alias la='ls -A'
alias l='ls -CF'
alias ll='ls -AFt1 --color | nl | head -15'
# some git aliases
alias gs='git status'
alias ga='git add'
alias gaf='git add .'
alias dotfiles='cd ~/dotfiles'
alias gp='git push'
alias powershellfolder='cd /mnt/c/Windows/System32/WindowsPowerShell/v1.0'
alias bin='cd ~/bin'
alias rnginx='systemctl restart nginx.service'
alias snginx='systemctl status nginx.service'
alias add='git add'
alias gommit="git commit -m \"${*}\""
alias v="vim"
alias vl='vim -c "normal '\''0"' #'"
alias lvim='vim -c "normal '\''0"' #'"
alias cx='function abc(){ [[ -d $(cdbetter $1) ]] && cd "$(cdbetter $1)" || vim "$(cdbetter $1)"; };abc $1'
alias 1='cx 1 && ll'
alias 2='cx 2 && ll'
alias 3='cx 3 && ll'
alias 4='cx 4 && ll'
alias 5='cx 5 && ll'
alias 6='cx 6 && ll'
alias 7='cx 7 && ll'
alias 8='cx 8 && ll'
alias 9='cx 9 && ll'
alias 10='cx 10 && ll'
alias 11='cx 11 && ll'
alias 12='cx 12 && ll'
alias 13='cx 13 && ll'
alias 14='cx 14 && ll'
alias 15='cx 15 && ll'
alias 16='cx 16 && ll'
alias 0='cd ..'
alias v='vimselectfile'
alias pus='git push 2>/dev/null &'
alias vv='vimselectfile --quick'
alias s='status'
alias ug='updateGit'
alias b='pushd ~/bin && ll'
alias vess="/usr/share/vim/vim80/macros/less.sh"
alias reload="systemctl reload"
alias ig="grep -i"
