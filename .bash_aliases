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
alias commit="git commit -m $@"
alias push="git push"
alias diff="git d"
