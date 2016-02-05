# My awesome bash prompt
#
# Copyright (c) 2012 "Cowboy" Ben Alman
# Licensed under the MIT license.
# http://benalman.com/about/license/
#
# Example:
# [master:!?][cowboy@CowBook:~/.dotfiles]
# [11:14:45] $
#
# Read more (and see a screenshot) in the "Prompt" section of
# https://github.com/cowboy/dotfiles

# ANSI color codes
RS="\[\033[0m\]"            # reset
HC="\[\033[1m\]"            # hicolor
UL="\[\033[4m\]"            # underline
INV="\[\033[7m\]"           # inverse background and foreground
FBLK="\[\033[30m\]"         # foreground black
FRED="\[\033[31m\]"         # foreground red
FGRN="\[\033[32m\]"         # foreground green
FYEL="\[\033[33m\]"         # foreground yellow
FBLE="\[\033[34m\]"         # foreground blue
FMAG="\[\033[35m\]"         # foreground magenta
FCYN="\[\033[36m\]"         # foreground cyan
FWHT="\[\033[37m\]"         # foreground white
BBLK="\[\033[40m\]"         # background black
BRED="\[\033[41m\]"         # background red
BGRN="\[\033[42m\]"         # background green
BYEL="\[\033[43m\]"         # background yellow
BBLE="\[\033[44m\]"         # background blue
BMAG="\[\033[45m\]"         # background magenta
BCYN="\[\033[46m\]"         # background cyan
BWHT="\[\033[47m\]"         # background white

# Arch Linux color codes

# Reset
Reset='\[\e[0m\]'           # Text Reset
RBold='\[\e[21m\]'          # Reset Bold
RDim='\[\e[22m\]'           # Reset Dim
RItalic='\[\e[23m\]'        # Reset Italic
RUnder='\[\e[24m\]'         # Reset Underline
RBlink='\[\e[25m\]'         # Reset Blink
RRev='\[\e[27m\]'           # Reset Reverse colours
RHidden='\[\2e[8m\]'        # Reset Hidden

# Formatting Modes
Norm='\[\e[0m\]'            # Normal
Bold='\[\e[1m\]'            # Bold
Dim='\[\e[2m\]'             # Dim
Italic='\[\e[3m\]'          # Italic
Under='\[\e[4m\]'           # Underline
Blink='\[\e[5m\]'           # Blink
Rev='\[\e[7m\]'             # Reverse colours
Hidden='\[\e[8m\]'          # Hidden

# Regular Colors
Black='\[\e[30m\]'          # Black
Red='\[\e[31m\]'            # Red
Green='\[\e[32m\]'          # Green
Yellow='\[\e[33m\]'         # Yellow
Blue='\[\e[34m\]'           # Blue
Purple='\[\e[35m\]'         # Purple
Cyan='\[\e[36m\]'           # Cyan
White='\[\e[37m\]'          # White

# Background
On_Black='\[\e[40m\]'       # Black
On_Red='\[\e[41m\]'         # Red
On_Green='\[\e[42m\]'       # Green
On_Yellow='\[\e[43m\]'      # Yellow
On_Blue='\[\e[44m\]'        # Blue
On_Purple='\[\e[45m\]'      # Purple
On_Cyan='\[\e[46m\]'        # Cyan
On_White='\[\e[47m\]'       # White

# High Intensity
IBlack='\[\e[90m\]'         # Black
IRed='\[\e[91m\]'           # Red
IGreen='\[\e[92m\]'         # Green
IYellow='\[\e[93m\]'        # Yellow
IBlue='\[\e[94m\]'          # Blue
IPurple='\[\e[95m\]'        # Purple
ICyan='\[\e[96m\]'          # Cyan
IWhite='\[\e[97m\]'         # White

# High Intensity backgrounds
On_IBlack='\[\e[100m\]'     # Black
On_IRed='\[\e[101m\]'       # Red
On_IGreen='\[\e[102m\]'     # Green
On_IYellow='\[\e[103m\]'    # Yellow
On_IBlue='\[\e[104m\]'      # Blue
On_IPurple='\[\e[105m\]'    # Purple
On_ICyan='\[\e[106m\]'      # Cyan
On_IWhite='\[\e[107m\]'     # White

if [[ ! "${prompt_colors[@]}" ]]; then
  prompt_colors=(
    $Reset                # 0: Reset
    $Bold$Under$IYellow   # 1: user colour
    $Bold$Blue            # 2: path colour
    $Blue                 # 3: time colour
    $Bold$Blue            # 4: prompt colour
    $Bold$Red             # 5: error colour
  )

  if [[ "$SSH_TTY" ]]; then
    # connected via ssh
    prompt_colors[1]=$Green
  elif [[ "$USER" == "root" ]]; then
    # logged in as root
    prompt_colors[1]=$Purple
  fi

fi

# Inside a prompt function, run this alias to setup local $c0-$c9 color vars.
#alias prompt_getcolors='prompt_colors[9]=; local i; for i in ${!prompt_colors[@]}; do local c$i="\[\e[0;${prompt_colors[$i]}m\]"; done'
alias prompt_getcolors='local i; for i in ${!prompt_colors[@]}; do local c$i="${prompt_colors[$i]}"; done'

# Exit code of previous command.
function prompt_exitcode() {
  prompt_getcolors
  [[ $1 != 0 ]] && echo " $c5[Error $1]$c0"
}

# Git status.
function prompt_git() {
  prompt_getcolors
  local status output flags branch
  status="$(git status 2>/dev/null)"
  [[ $? != 0 ]] && return;
  output="$(echo "$status" | awk '/# Initial commit/ {print "(init)"}')"
  [[ "$output" ]] || output="$(echo "$status" | awk '/# On branch/ {print $4}')"
  [[ "$output" ]] || output="$(git branch | perl -ne '/^\* \(detached from (.*)\)$/ ? print "($1)" : /^\* (.*)/ && print $1')"
  flags="$(
    echo "$status" | awk 'BEGIN {r=""} \
        /^(# )?Changes to be committed:$/        {r=r "+"}\
        /^(# )?Changes not staged for commit:$/  {r=r "!"}\
        /^(# )?Untracked files:$/                {r=r "?"}\
      END {print r}'
  )"
  if [[ "$flags" ]]; then
    output="$output$c1:$c0$flags"
  fi
  echo "$c1[$c0$output$c1]$c9"
}

# hg status.
function prompt_hg() {
  prompt_getcolors
  local summary output bookmark flags
  summary="$(hg summary 2>/dev/null)"
  [[ $? != 0 ]] && return;
  output="$(echo "$summary" | awk '/branch:/ {print $2}')"
  bookmark="$(echo "$summary" | awk '/bookmarks:/ {print $2}')"
  flags="$(
    echo "$summary" | awk 'BEGIN {r="";a=""} \
      /(modified)/     {r= "+"}\
      /(unknown)/      {a= "?"}\
      END {print r a}'
  )"
  output="$output:$bookmark"
  if [[ "$flags" ]]; then
    output="$output$c1:$c0$flags"
  fi
  echo "$c1[$c0$output$c1]$c9"
}

# SVN info.
function prompt_svn() {
  prompt_getcolors
  local info="$(svn info . 2> /dev/null)"
  local last current
  if [[ "$info" ]]; then
    last="$(echo "$info" | awk '/Last Changed Rev:/ {print $4}')"
    current="$(echo "$info" | awk '/Revision:/ {print $2}')"
    echo "$c1[$c0$last$c1:$c0$current$c1]$c9"
  fi
}

# Maintain a per-execution call stack.
prompt_stack=()
trap 'prompt_stack=("${prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

function prompt_command() {
  local exit_code=$?
  # If the first command in the stack is prompt_command, no command was run.
  # Set exit_code to 0 and reset the stack.
  [[ "${prompt_stack[0]}" == "prompt_command" ]] && exit_code=0
  prompt_stack=()

  # Manually load z here, after $? is checked, to keep $? from being clobbered.
  [[ "$(type -t _z)" ]] && _z --add "$(pwd -P 2>/dev/null)" 2>/dev/null

  # While the simple_prompt environment var is set, disable the awesome prompt.
  [[ "$simple_prompt" ]] && PS1='\n$ ' && return

  prompt_getcolors
  # http://twitter.com/cowboy/status/150254030654939137
  PS1="" # PS1="\n" for newline before prompt
  # svn: [repo:lastchanged]
  PS1="$PS1$(prompt_svn)"
  # git: [branch:flags]
  PS1="$PS1$(prompt_git)"
  # hg:  [branch:flags]
  PS1="$PS1$(prompt_hg)"
  # misc: [cmd#:hist#]
  # PS1="$PS1$c1[$c0#\#$c1:$c0!\!$c1]$c9"
  # path: user@host: path
  PS1="$PS1$c1\u@\h:$c0 $c2\w$c0"
  PS1="$PS1\n"
  # date: [HH:MM:SS]
  PS1="$PS1$c3[$(date +"%H:%M:%S")]$c0"
  # exit code: 127
  PS1="$PS1$(prompt_exitcode "$exit_code")"
  PS1="$PS1 $c4\$$c0 "
}

PROMPT_COMMAND="prompt_command"
