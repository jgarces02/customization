# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
alias ll="ls -lh"
alias ..="cd ../"
alias ...="cd ../../"
alias sq="squeue"

# Prompt customization
export PS1="\[\e[32m\][\[\e[m\]\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]\[\e[32m\]]\[\e[m\] \[\e[36m\]\w\[\e[m\] \[\e[36m\]·\[\e[m\] "
umask 007

# Colors by file extension
LS_COLORS="*.sbs=32:*.out=33"
