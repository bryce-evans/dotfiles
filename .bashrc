# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=no
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[38;5;202m\]\w\[\033[00m\]\$ ' #35 is a good purple.
else
    PS1='\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


###################### BEGIN MY BASHRC ###############################

############### SYSTEM

installdeb() {
  sudo dpkg -i $1 sudo apt-get install -f;
}

alias smi="nvidia-smi";

# Vim edit
# Opens results of command into vim as separate tabs.
# e.g. `v ls -f` opens all files in folder in vim.
# Can pair with git commands e.g. `v git conflicts`
v() {
  vim -p $($@);
}

# Screen capture directly to clipboard.
sc() {
  gnome-screenshot -a -c;
}

# Human readable top level disk usage of a folder.
disk(){
  du -h -d1 $1 | sort -n;
}
# 
# docker system prune --all --force

# Human readable top level disk usage of files.
diskfiles(){
  du -ah $1 | sort -n;
}

hard-clean-force-all() {

# delete all the build caches and logs.
sudo rm -rf ~/.cache

# Delete every Docker containers
# Must be run first because images are attached to containers
docker rm -f $(docker ps -a -q)

# Delete every Docker image
docker rmi -f $(docker images -q)
}
############### WINDOW SETUP

newdev() {
  terminator -l dev &
}
alias newterminator="newdev";

newchrome() {
  google-chrome --new-window https://cruise.slack.com/ https://calendar.google.com/calendar/r/week https://docs.google.com/document/d/1QgECqdIepl9zJfE5Sb1g5SGPgaWnnhjP6hcQnh5aGXE/edit#  https://wiki.robot.car/index.action https://github.robot.car/cruise/cruise/pulls/bryce-evans &
}
newall() {
  newdev; newchrome;
}
alias newworkspace="newall";


########################## SCRIPTS
########### Replace

global_replace(){
  python2 ~/scripts/global_replace.py $1 $2
}

global_rename(){
  python3 ~/scripts/global_rename.py $1 $2
}

########### Other

# Transforms `path/to/my.file:##` to `vim +##  path/to/my.file`
open_to_line(){
  python3 ~/scripts/open_to_line.py $1
}

######################################################################
# COLORS

GREEN='\033[1;32m';
BLUE='\033[1;34m';
CYAN='\033[1;36m';
GRAY='\033[1;30m';
RED='\033[1;91m';
NO_COLOR='\033[0m';
BOLD='\033[1m';
BLINK='\033[5m';
NORMAL='\033[0m';

######################################################################
# OTHER CONSTANTS

export VAULT_ADDR=https://vault.secure.car:8200

######################################################################
### UTILTIES

new() {
  exec bash; 
  echo "Restarted.";
}
silence() {
  #eval "$@" 2>&1;
  echo "silence not working"
  return 1
}

# usage: optional <val> <default>
alias optional="${1-$2}";

echo_overwrite() {
  echo -e "\e[0K\r";
}

# Silent push.
spushd() {
  pushd . > /dev/null;
}

# Silence pop.
spopd() {
  popd > /dev/null;
}

latest() {
  dir=$1
  ls -1t $dir | awk '{ print "${dir}/${1}"; exit}'
}

# Run from root of repo.
toplevel() {
  spushd;
  bcd;
  if [[ $? -ne 0 ]]; then
    echo "Repo not set";
    return -1;
  fi
  $@;
  spopd;
}
alias tl=toplevel

alias ag='ag --path-to-ignore ~/.ignore'
# Redirect to silence for no output.
#silence > /dev/null 2>&1;

# Pipe to remove newlines.
NONEWLINE="tr -d '\n'";

date_string() {
  date +%Y-%m-%d_%H:%M:%S;
}

# Random character string. Optionally give length.
random_string() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

time_string() {
  TZ=EST8EDT  date +%H_%M_%S;
}

occurances_of_char_in_str() {
  local char=$1
  local str=$2
  if [[ $(expr length "${char}") != 1 ]]; then
    echo "usage: occurances_of_char_in_str c string";
  fi
  awk -F"${char}" '{print NF-1}' <<< "${str}";
}

split_string() {
  local str=$1
  local delimiter=$2
  local s=$str$delimiter
  array=();
  while [[ $s ]]; do
      array+=( "${s%%"$delimiter"*}" );
      s=${s#*"$delimiter"};
  done;
  echo ${array[@]}
}

trim_after_char() {
  echo "$1" | awk -F${2} '{print $1}';
}

trim_before_char() {
  echo "$1" | awk -F${2} '{print $2}';
}

##########################################
# Short helpers

alias vaultlogin="printf \"${CYAN}DUO PASSWORD, not desktop password!${NORMAL}\n\"; vault login -method=okta username=bryce.evans";

vshell() {
  bcd; OTHER_VOLS="-v /home/bevans/.bashprofile:/home/cruise/.bashprofile" make shell;
}

rshell() {
  tag=${1:-cyclops}
  bcd; OTHER_VOLS="-v /data/:/opt/robotorch/data -v /home/bevans/.bashprofile:/opt/robotorch/.bashprofile" make shell TAG=${tag} DOCKERFILE=project/cyclops/Dockerfile;
}

gcloudsetup() {
  gcloud auth list | grep getcruise.com || gcloud auth login > /dev/null 2>&1;
  gcloud config set account bryce.evans@getcruise.com;
  sudo usermod -a -G docker $USER;
  gcloud auth configure-docker;
}

gclogin(){
  gcloud auth login --update-adc
}

viewgraph() {
  net_path=/tmp/frozen_graph_$(date_string).pb;
  printf "${GREEN}Downloading to $net_path${NORMAL}\n";
  gsutil cp $1 $net_path 2>&1;
  eval netron $net_path 2>&1;
}

upload() {
  root="gs://vivarium-ml-jobs/bae/"
  src=$1
  dir=$2
  dst="${root}${dir}"

  if test -f "$src"; then
    printf "\n${GREEN}Uploading $src to $dst\n\n${NORMAL}"
    gsutil cp $src $dst;
  else
    printf "${RED}File $1 does not exist\n\n${NORMAL}";
  fi
}
###### GIT ######################

# Set git config (run once).
# git config --global push.default current
# git config --global core.editor "vim"

GIT_BRANCH_PROD="origin/develop-stable"
GIT_BRANCH_DEV="origin/develop"
GIT_BRANCH_TARGET=$GIT_BRANCH_PROD;

gitsha() {
  git rev-parse HEAD;
}

gitbranch() {
  git rev-parse --abbrev-ref HEAD | $NONEWLINE;
}
alias cur_branch="gitbranch";
alias cb='printf "${GREEN}$(gitbranch)\n${NORMAL}"'

gitroot() {
  git rev-parse --show-toplevel;
}

gitpwd() {
  git rev-parse --show-prefix;
}

gitrecent() {
   git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %    (authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
}

# Takes bare words as a message and commits & pushes all changes
# e.g. push this is my commit message
commit() {
  pushd . &> /dev/null;
  bcd;
  git add --a;
  cmd="git commit -m \"$@\"";
  echo $cmd; 
  eval $cmd;
  popd &> /dev/null;
} 
push() {
  commit $@;
  git push origin;
}

# Lists all conflicted files.
# Also supported in git config for `git conflicts`
gitconflicts() {
  git diff --name-only --diff-filter=U;
}

# Edit all conflicts.
vimgitconflicts() {
  if [[ $(gitconflicts | wc -l) == 0 ]]; then
    echo "No conflicts";
    return;
  fi 

  tl v gitconflicts;
}
alias vgc="vimgitconflicts";

githaschanges() {
  if [[ ! -z "$(git status --porcelain)" ]]; then
    return 1;
  else
    return 0;
  fi
}

alias gitprchanges='base=${1-$GIT_BRANCH_DEV}; git diff "$(git merge-base ${base} HEAD)"..HEAD';
alias gitprfiles='base=${1-$GIT_BRANCH_DEV}; git diff --name-only "$(git merge-base ${base} HEAD)"..HEAD';
alias gitprfilesc='gitprfiles | wc -l';

branchreset() {
git fetch origin;
git checkout $(basename $(gitroot));
git reset --hard $GIT_BRANCH_TARGET;
}

branchupdate() {
  git fetch origin;
  git merge $GIT_BRANCH_TARGET;
}

copychanges() {
  target=$1;
  dst=$2;
  
  pushd .;

  diff=/tmp/`gitsha`.diff;
  
  result=$(git diff --stat "$(git merge-base ${base} HEAD)"..HEAD -- $target);
  printf "\nCopying changes:\n $result\n\n";

  git diff "$(git merge-base ${base} HEAD)"..HEAD -- $target > $diff;
  cd ~/dev/${dst}/;
  git apply $diff;
  #rm $diff;
  popd;
}

movechanges() {
  copychanges $1 $2;
  echo "TODO: no move done, only copy implemented. copy complete.";
}
############################# 
# Recursively find files containing input in name.
f() {
  find -iname "*$1*" -type f;
}

# Recursively find directories containing input in name.
fd() {
  find . -type d -name "*$1*" -print 2>/dev/null
}

# Returns the name of the repo we are in without full path.
# e.g. d1
repoid() {
  basename $(gitroot);
}

commit_date() {
  git log -1 --format=%cd | $NONEWLINE;
}

commit_date_relative() {
  git log -1 --format=%ar | $NONEWLINE;
}

lint() {
  toplevel make fix;
  printf "Confirming lint now passes...\n"
  output=$(toplevel make lint)
  if [[ $(echo $output | tail -1)  == *"Success"* ]]; then
    printf "${GREEN}lint: Success!! :D ${NORMAL}\n"
    git diff --stat;
  else
    printf "${RED}lint: Failure!! D: ${NORMAL}\n"
    printf "$output\n"
  fi
  
}

ansible() {
  toplevel ./setup/run_ansible.sh;
}

# Fast build a minimal set for cruisepy build
fastbuildall() {
tl bazel build --config=remote-only --jobs=400 $(bazel query "//... - tests(//...) - attr(tags, manual, //...)") //:dev //:devtools;
}

# For each repo, runs function with args and repo, repo_full_path
repo_foreach() {
  CUR_DIR=${PWD};

  pushd . &> /dev/null; bcd; 
  CUR_REPO=${PWD##*/};
  popd &> /dev/null;
  
  pushd . > /dev/null;
  # Cruise driving repos.
  for i in m f {1..6}; do
    if ! `cruise cd d${i}` > /dev/null 2>&1; then
      printf "${RED}d${i}: not found.${NO_COLOR}\n";
      continue;
    fi

    $@;

  done;
 
  echo " ";
 
  # Vivarium repos.
  for i in {1..3}; do
    if ! cd ~/${i}vivarium > /dev/null 2>&1; then
      printf "${RED}${i}vivarium: not found.${NO_COLOR}\n";
      continue;
    fi

    $@;

  done;

  popd > /dev/null 2>&1;
}

# For each repo, runs function with args and repo, repo_full_path
repo_foreach_fast() {
  CUR_DIR=${PWD};

  pushd . &> /dev/null; bcd; 
  CUR_REPO=${PWD##*/};
  popd &> /dev/null;
  
  pushd . > /dev/null;
  # Cruise driving repos.
  for i in m f {1..6}; do
    if ! cd ~/dev/d${i} > /dev/null 2>&1; then
      printf "${RED}d${i}: not found.${NO_COLOR}\n";
      continue;
    fi
    $@;
  done;
 
  echo " ";
 
  # Vivarium repos.
  for i in {1..3}; do
    if ! cd ~/${i}vivarium > /dev/null 2>&1; then
      printf "${RED}${i}vivarium: not found.${NO_COLOR}\n";
      continue;
    fi
    $@;
  done;

  echo " ";

  # Robotorch repos.
  for i in {1..4}; do
    if ! cd ~/${i}robotorch > /dev/null 2>&1; then
      printf "${RED}${i}robotorch: not found.${NO_COLOR}\n";
      continue;
    fi
    $@;
  done;

  echo " ";
 
  # Other repos.
  for i in "galileo-scopes"; do
     if ! cd ~/${i} > /dev/null 2>&1; then
      printf "${RED}${i}: not found.${NO_COLOR}\n";
      continue;
    fi
    $@;
  done;

  popd > /dev/null 2>&1;
}


repo_status() {
    repo=${PWD##*/};
    repo_full_path=${PWD};

    COLOR=${GREEN}

    curbranch=$(cur_branch);
    if [[ ${curbranch} == $(repoid) ]] ; then
       curbranch="(new)";
    fi
   
#    changed=$(githaschanges);
#    if [[ $changed -eq 1 ]];
#    then changed_text="*";
#    else changed_text="";
#    fi    

    # Branch to highlight the output of our current directory.
    if [[ ${CUR_REPO} == ${repo} ]] ;
    then
      printf "${GREEN}${repo}: ${curbranch}${changed_text} ($(commit_date_relative))\n${NO_COLOR}${NORMAL}";
    else
      printf "${GRAY}${repo}: ${NO_COLOR}${curbranch}${changed_text} ${BLUE}($(commit_date_relative))\n${NO_COLOR}${NORMAL}";
    fi
}

# Shows status of all repos (current branch and date).
rs() {
  repo_foreach_fast repo_status;
}  

# Source the workspace.
ws() {
  source ros/scripts/run_setup.sh;
  tl bazel build //:_catkin_ws > /dev/null;
  #if [[ $? == Info* ]]; then
  #  spushd;
  #    echo "Rebuild ROS environment needed. Building...";
  #  spopd;
  #fi
}

bcd_driving(){
  cd ~/${1}cruise;
  cdrs;
  rs;
}
cruise_env_cd(){
  cruise cd d${1};
  cdrs;
  rs;
}


bcd_vivarium() {
  cd ~/${1}vivarium;
  # <set bazel root to current root>;
  REPO=${1}vivarium;
  rs;
}

bcd_robotorch() {
  cd ~/${1}robotorch;
  # <set bazel root to current root>;
  REPO=${1}robotorch;
  rs;
}


# Hack for when bazel doesn't work.
bcd() {
  cd `gitroot`;
}
cdrs() {
  bcd;
  cd ros/src;
}

bb() {
  if [ "$#" -eq 0 ]; then
    bazel build ...;
  else
    bazel build $@;
  fi
}

bt() {
  if [ "$#" -eq 0 ]; then
    bazel test ...;
  else
    bazel test $@;
  fi
}

alias bcdm="cruise_env_cd m"
alias bcdf="cruise_env_cd f"
alias bcd1="cruise_env_cd 1"
alias bcd2="cruise_env_cd 2"
alias bcd3="cruise_env_cd 3"
alias bcd4="cruise_env_cd 4"
alias bcd5="cruise_env_cd 5"
alias bcd6="cruise_env_cd 6"

alias dm="bcdm"
alias df="bcdf"
alias d1="bcd1"
alias d2="bcd2"
alias d3="bcd3"
alias d4="bcd4"
alias d5="bcd5"
alias d6="bcd6"
# make the system df available
alias dff="/bin/df"

alias c1="bcd_driving 1"
alias c2="bcd_driving 2"
alias c3="bcd_driving 3"
alias c4="bcd_driving 4"
alias c5="bcd_driving 5"
alias c6="bcd_driving 6"

alias v1="bcd_vivarium 1"
alias v2="bcd_vivarium 2"
alias v3="bcd_vivarium 3"

alias r1="bcd_robotorch 1"
alias r2="bcd_robotorch 2"
alias r3="bcd_robotorch 3"
alias r4="bcd_robotorch 4"

alias p1="bcd; cd ros/src/appearance_embedding";
alias p2="bcd; cd ros/src/deepbox";
alias p3="bcd; cd ros/src/emv_classification";
alias p4="bcd; cd ros/src/vision_msgs/msg/";
alias p5="bcd; cd ros/src/visual_fusion/";

alias p="p1";
alias ae="p1";
alias db="p2";
alias emv="p3";
alias vm="p4";
alias vf="p5";
alias cdc="bcd; cd project/cyclops";
alias scopes="cd ~/galileo-scopes";

######### SEARCH
gg() {
  if [ -z "$1" ]
  then
    echo "Usage: gg bare word git grep";
    return 0;
  fi 

  search="$@";
  git grep --untracked "$search" ':(exclude)*.ipynb';
}

ggno() {
  if [ -z "$1" ]
  then
    echo "Usage: ggno bare word git grep --name-only";
    return 0;
  fi 

  search="$@";
  git grep --untracked --name-only "$search" ':(exclude)*.ipynb';
}


# Allow selection options
# source ./select_option.sh


# Rendess a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 255
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
#                 255 is returned if selection was canceled or unsuccessful.
function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { 
                         read -s -n3 key 2>/dev/null >&2
                         if [[ $key = "q" ]]; then echo quit;
                         elif [[ $key = $ESC[A ]]; then echo up; 
                         elif [[ $key = $ESC[B ]]; then echo down; 
                         elif [[ $key = ""     ]]; then echo enter; 
                         else echo unknown; 
                         fi; 
                       }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            quit) return -1;;
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
            *) echo "key not recognized"; return -1;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

# Fuzzy search files for opening in vim. Allow selection if multiple matches.
on() {
  cap=20;
  array=()
  array_short=()
  files_found=0
  while IFS=  read -r -d $'\0'; do
    array+=("$REPLY");
  done < <(find . -name "$1" -type f -print0);

  files_found=${#array[@]};
  if (( $files_found == 0 )); then
    printf "No Files Found. Perhaps use a wildcard \"*\"?\n";
  elif (( $files_found == 1 )); then
    open_to_line $array;
    return 0;
  elif (( $files_found > ${cap} )); then
    array_short=${array[@]:0:$cap};
    printf "${GREEN}${files_found} Results.${BLUE} Displaying first ${cap}${NO_COLOR}.\n"
  fi

  tmp_cols=$COLUMNS;
  COLUMNS=1;

  select option in ${array_short[@]}
  do
    # Check that option is valid
    if (( ${#option} == 0 )); then
      break;
    fi
   open_to_line $option;
   break;
  done
  COLUMNS=$tmp_cols;
}

# Fuzzy search files for opening in vim. Allow arrow keys to select if multiple matches.
o() {
 if [ -z "$1" ]
  then
    echo "Usage: o bare word fuzzy file search";
    return 0;
  fi 

  search_file=$(trim_after_char "$1" ":")
  line_number=$(trim_before_char "$1" ":")

  cap=20;
  array=()
  array_short=()
  files_found=0
  while IFS=  read -r -d $'\0'; do
    array+=("$REPLY");
  done < <(find . -name "$search_file" -type f -print0);

  files_found=${#array[@]};
  if (( $files_found == 0 )); then
    printf "No Files Found. Perhaps use a wildcard \"*\"?\n";
    return 0;
  elif (( $files_found == 1 )); then
    vim +$line_number $array;
    return 0;
  elif (( $files_found > ${cap} )); then
    array_short=${array[@]:0:$cap};
    printf "${GREEN}${files_found} Results.${BLUE} Displaying first ${cap}${NO_COLOR}.\n"
  else
    array_short=${array[@]}
  fi
  select_option ${array_short[@]}
  option=$?;
  # exit if the selection was unsuccessful or canceled.
  if [ $option -eq 255 ]; then
    return;
  fi
  vim +$line_number ${array[$option]};
}

# Search directories to jump to. Allow selection if multiple matches.
fcd() {
  cap=20;
  array=()
  array_short=()
  files_found=0
  while IFS=  read -r -d $'\0'; do
    array+=("$REPLY");
  done < <(find . -name "$1" -type d -print0);

  files_found=${#array[@]};
  if (( $files_found == 0 )); then
    printf "No Files Found.\n";
  elif (( $files_found == 1 )); then
    cd $array;
    return 0;
  elif (( $files_found > ${cap} )); then
    array_short=${array[@]:0:$cap};
    printf "${GREEN}${files_found} Results.${BLUE} Displaying first ${cap}${NO_COLOR}.\n"
  fi

  tmp_cols=$COLUMNS;
  COLUMNS=1;

  select option in ${array_short[@]}
  do
    # Check that option is valid
    if (( ${#option} == 0 )); then
      break;
    fi
   cd $option;
   break;
  done
  COLUMNS=$tmp_cols;
}

# run a bazel test, but pass in a filename (because that's easier to get with fzf + ctrl-t)
bpt ()
   {
       # usage:
       # bpt ros/src/perception_scenarios/smoke/tracked_and_predicted_object/all_sensors_tableflow.yaml -d /tmp/out
      local yaml=$1;
      local yaml_stripped=//$(echo $yaml | sed "s/\.yaml//" | sed "s/perception_scenarios\//perception_scenarios:/");
      local other_args="${@:2}";
      local extra_args=;
      for arg in "${@:2}";
      do
          extra_args=$(echo "$extra_args $arg");
      done;
      echo bazel run //ros/src/perception_testing:perc -- --testsuite $yaml $extra_args;
      bazel run //ros/src/perception_testing:perc -- --testsuite $yaml $extra_args
  }


##################### Cruise specific utilities

## SSH into a high memory machine for retraining SMC.
sshsmc() {
ssh -A ubuntu@10.208.5.12
}

# List, count, and give example of tests.
tests() {
  if [[ $1 == "ls" ]]; then
    tl find ros/src/perception_scenarios/$2 -name *.yaml; 
  fi;
  if [[ $1 == "count" ]]; then
    tl find ros/src/perception_scenarios/$2 -name *.yaml | wc -l; 
  fi;
  if [[ $1 == "ex" ]]; then
    find ros/src/perception_scenarios/$2 -name *.yaml | head -1 | xargs cat;
  fi;
}

hydra() {
  google-chrome https://hydra.robot.car/jobs/${1};
}

trigger_smoke() {
   tl bazel run --config=python3 //ci:trigger_tests -- --branch $(cur_branch) --no-retries --scenario-groups smoke --manual-authentication
}

trigger_test_suite() {
tl bazel run --config=python3 //ci:trigger_tests -- --branch $(cur_branch) --no-retries  --manual-authentication --test-suite $1
}

trigger_vision_all() {
# (this is the new MSL vision segments to check general vision metrics
# Vision metrics
trigger_test_suite teams/detection/blue_dragon/; 
# to check e2e general metrics
# Look at safety and comfort score
trigger_test_suite metrics/blue_dragon/sce/valid/multi-tick; 
# Hardbrake prediction tests
# Look at scoope for number of hardbrakes
trigger_test_suite metrics/random_sample/01_10_20/valid
# End to end tests
# Look at safety and comfort score
trigger_test_suite metrics/feature_testing/exiting_driveway/e2e;
# Tracking metrics.
# Look at Canary and old tracking metrics scope
trigger_test_suite metrics/feature_testing/exiting_driveway/tracking_kpis;
# General Tracking KPI
# Use with Tracking metrics.
trigger_test_suite metrics/blue_dragon/tracking_kpi/batch-00/;
}


trigger_single_node_tests() {
 tl ci/trigger_tests.py --branch b/artifact-regen --test-suites teams/tracking_stack/single_node/metrics/raildar_blue_dragon/test
}

trigger_replay_tests() {
  tl ~/scripts/trigger_replay_tests.sh;
}

trigger_tracking_metrics() {
  # tl ci/trigger_tests.py --branch $(cur_branch) --no-retries --test-suite metrics/blue_dragon/tracking_kpi/
tl bazel run --config=python3 //ci:trigger_tests -- --branch $(cur_branch) --no-retries --test-suite metrics/blue_dragon/tracking_kpi/ --manual-authentication
}

trigger_single_test() {
tl bazel run --config=python3 //ci:trigger_tests -- --branch $(cur_branch) --no-retries --manual-authentication --test-suite metrics/blue_dragon/tracking_kpi/batch-05/5G21A6P02L4100122_1571331480_1571331500.yaml
}

tfalseest_yaml() {
tl bazel run //ros/src/perception_testing:perc -- -t ros/src/perception_scenarios/$@;
}

view_tracking_metrics() {
# $1 is base, $2 is feature.
base=$1;
feature=$2;
echo "base: $base"
echo "feature: $feature"
google-chrome https://scopes.robot.car/scope/tracking/metrics/?obj-type=tracking&per-frame-agg=sum&per-segment-agg=sum&per-job-agg=sum&global-avg=yes&limit-labels-in-both-jobs=False&base=${base}&feature=${feature} 
}
## TEMP commands
cyclops(){
if [[ $1 == "build" ]]
then
  tl cp ~/.bashprofile .
  tl make docker-build TAG=cyclops DOCKERFILE=project/cyclops/Dockerfile;
elif [[ $1 == "train" ]]
then
    flags=""
    if [ $# -eq 2 ]
      then
      flags="--weights-path=${2}"
      printf "Loaded ${2}"
    fi
    tl python -m project.cyclops.run train --config project/cyclops/config.jen --job-dir experiments/cyclops --max-training-steps=10000 $flags;
elif [[ $1 == "train_distributed" ]]
then
    tl python -m torch.distributed.launch --nproc_per_node=2 -m project.cyclops.run train --config project/cyclops/config.jen --job-dir experiments/ --max-training-steps 1000
elif [[ $1 == "debug" ]]
then
    tl python -m project.cyclops.run train --config project/cyclops/debug_config.jen --job-dir experiments/cyclops --max-training-steps=1000;
elif [[ $1 == "profile" ]]
then
    tl python -m cProfile -o cprofile_results.prof project/cyclops/run.py train --config project/cyclops/debug_config.jen --job-dir experiments/cyclops --max-training-steps=10;
elif [[ $1 == "viz" ]]
then
    tl python -m project.cyclops.run visualize_data --config project/cyclops/config.jen --job-dir project/cyclops/visualize_data;
elif [[ $1 == "eval" ]]
then
    tl python -m project.cyclops.run eval --config project/cyclops/config.jen --job-dir experiments/cyclops_eval --checkpoint $2;
else
    echo "usage: cylops [train | train_distributed | eval | profile | viz]"
fi
}
#cyclops() {
#complete -W "train viz" cyclops
#}


cyclops_eval() {
  jobid=$1
  if [ $# -eq 2 ]
  then 
    userid=$2
  else
    userid="bryce.evans"
  fi
  cdc;
  cmd="flow submit --job-id eval__${jobid} eval --checkpoint gs://vivarium-ml-jobs/${userid}/perception/cyclops/${jobid}/checkpoint_latest.ckpt"
  echo $cmd;
  $cmd;
}

latest_ckpt() {
echo "gs://vivarium-ml-jobs/bryce.evans/perception/cyclops/${1}/checkpoint_latest.ckpt";
}
