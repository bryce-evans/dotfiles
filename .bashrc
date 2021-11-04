# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# case $- in
#     *i*) ;;
#       *) return;;
# esac

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
# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

src() {
  source ~/.bashprofile;
}

vbp() {
  vim ~/.bashprofile;
  src;
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

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[35;5;202m\]\w\[\033[00m\]\033[00m\]\$ '
    # PS1='\[\033[35;5;202m\]\w\[\033[00m\]\033[31m\]$(parse_git_branch)\033[00m\]\$ '
else
    PS1='\w\$ '
fi
unset color_prompt force_color_prompt

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

dockerprune() {
  docker system prune --all --force;
}

# Human readable top level disk usage of files.
diskfiles(){
  du -ah $1 | sort -n;
}

hard-clean-force-all() {
  # delete all the build caches and logs.
  sudo rm -rf ~/.cache;

  # Delete every Docker containers
  # Must be run first because images are attached to containers
  docker rm -f $(docker ps -a -q);

  # Delete every Docker image
  docker rmi -f $(docker images -q);
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
# OTHER CONSTANTS

# Managed repository data.
REPO_BASE_PATH="$HOME/verily/";

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

pipeshell() {
  bcd; OTHER_VOLS="-v /home/bevans/.bashprofile:/opt/vivarium/.bashprofile"  make pipeline-container-shell;
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

gl() {
  git --no-pager log --decorate=short --pretty="format:%C(white)commit %H%n%C(white)Author: %an <%ae>%n%C(white)Date:   %ad %C(yellow)(%ar)%n%n%C(white)%s%n" -n1;
}

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
  echo "TODO: not implemented. No move done, only copy.";
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

linecount() {
  find . -name "*$1" | xargs wc -l
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
  toplevel ./scripts/cpplint.sh;
  # printf "Confirming lint now passes...\n"
  # output=$(toplevel make lint)
  # if [[ $(echo $output | tail -1)  == *"Success"* ]]; then
  #   printf "${GREEN}lint: Success!! :D ${NORMAL}\n"
  #   git diff --stat;
  # else
  #   printf "${RED}lint: Failure!! D: ${NORMAL}\n"
  #   printf "$output\n"
  # fi
}


declare -A repo_data
REPOS=()

repo="surgical"
repo_data["${repo}__name"]="surgical"
repo_data["${repo}__prefix"]="r"
directories=( $(seq 1 3 ) m f)
repo_data["${repo}__ids"]=${directories[@]}
REPOS+=(${repo})


# For each repo, runs function with args and repo, repo_full_path
repo_foreach() {
  CUR_DIR=${PWD};

  pushd . &> /dev/null; bcd; 
  CUR_REPO=${PWD##*/};
  popd &> /dev/null;
  
  pushd . > /dev/null;

  for r in ${REPOS}; do
    for i in ${repo_data["${r}__ids"]}; do
      if ! cd ${REPO_BASE_PATH}${repo_data["${r}__prefix"]}${i} > /dev/null 2>&1; then
        printf "${RED}${repo_data["${r}__prefix"]}${i}: not found.${NO_COLOR}\n";
        continue;
      fi
      $@;
    done;
    echo " ";
  done;
 
  popd > /dev/null 2>&1;
}


repo_status() {
    unset repo;
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
  repo_foreach repo_status;
}  

# Define a set of functions
# <repo-prefix><repo_id> that take you to the directory location.
for id in ${repo_surgical["dir_names"]}; do
    eval "${repo_surgical["dir_prefix"]}${id}() { cd ${REPO_BASE_PATH}/${repo_surgical["dir_prefix"]}${id}; rs;}";
done


# Hack for when bazel doesn't work.
bcd() {
  cd `gitroot`;
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

### specific directory shortcuts.
alias p1="bcd; cd path/to/project/one";

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
    printf "${GREEN}${files_found} Results.${BLUE} Displaying first ${cap}.${NO_COLOR}\n"
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

#export GOOGLE_CLOUD_PROJECT=

## DOCKER
# 
# List containers
# docker container ls
#
# Take container id from results and open bash
# docker exec -t $ID bash
