# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# Package management
alias update="sudo apt-get -qq update && sudo apt-get upgrade"
alias install="sudo apt-get install"
alias remove="sudo apt-get remove"
alias search="apt-cache search"

<<<<<<< HEAD
# Make 'less' more friendly for non-text input (eg. .zip)
=======
alias say=spd-say

# Make 'less' more.
>>>>>>> upstream/master
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
