# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    i) ;;
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
    xterm-color) color_prompt=yes;;
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
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
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

# Default to some zooxrc for basic stuff.
source ~/1driving/scripts/shell/zooxrc.sh

alias aws-mfa="arn:aws:iam::069289935426:mfa/bryceevans"

export EDITOR=vim

alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

random-string() {
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

f() {
  find -iname "$1";
}


alias recentbranches="git for-each-ref --sort='-authordate:iso8601' --format=' %(authordate:relative)%09%(refname:short)' refs/heads";

alias resetbranch="git fetch; git checkout origin/master";

bcd_driving(){
  cd ~/${1}driving;
  source scripts/shell/zooxrc.sh;
  rstatus;
}

alias bb="bazel build"
alias bcd1="bcd_driving 1"
alias bcd2="bcd_driving 2"
alias bcd3="bcd_driving 3"
alias bcd4="bcd_driving 4"
alias bcd5="bcd_driving 5"
alias bcd6="bcd_driving 6"

alias d1="bcd_driving 1"
alias d2="bcd_driving 2"
alias d3="bcd_driving 3"
alias d4="bcd_driving 4"
alias d5="bcd_driving 5"
alias d6="bcd_driving 6"

alias calrepo="cd /etc/zoox/calibration/"

alias exp="cd experimental/bae"
alias emb="cd experimental/bae/embedding"

alias reporeset="git fetch; git checkout origin/master; rstatus;"

gitrecent() {
   git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %    (authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
}

cur_branch() {
  git rev-parse --abbrev-ref HEAD;
}
rstatus() {
  CURDIR=${PWD};
  pushd . > /dev/null;
  GREEN='\033[1;32m';
  CYAN='\033[1;36m';
  GRAY='\033[1;30m';
  NO_COLOR='\033[0m';
  BOLD='\033[1m';
  BLINK='\033[5m';
  NORMAL='\033[0m';
  for i in {1..6}; do
    cd ~/${i}driving;
    repo=${PWD##*/};
    COLOR=${GREEN}
    if [[ ${CURDIR} == ${repo} ]] ;
    then
      printf ${GREEN}${BLINK}${repo}": ";
      cur_branch;
      printf ${NO_COLOR}${NORMAL};
    else
      printf ${GRAY}${repo}": "${NO_COLOR};
      cur_branch;
    fi

  done;
  popd > /dev/null;
}

# Prints the number of entries that an lmdb contains.
entries(){
  python ~/2driving/experimental/bae/scripts/lmdb/entries.py $1
}

global_replace(){
  python ~/1driving/experimental/bae/scripts/global_replace.py $1 $2
}

delete_branch(){
  for i in {1..5}; do
    pushd ~/${i}driving;
    git branch -D ${1};
    popd;
  done;
}

#alias viewcam='bazel build vehicle/sensors/cameras/viewcam:viewcam &&
 # ./bazel-bin/vehicle/sensors/cameras/viewcam/viewcam --camera_uri "[cameras.FlyCapImageSourceOptions.ext]
#{serial_number:[15187914,15223367],image_width:1920,image_height:1200,sync:true}"'

alias viewcam="bazel build //vehicle/sensors/cameras/viewcam:viewcam && ~/1driving/bazel-bin/vehicle/sensors/cameras/viewcam/viewcam --camera_uri '[cameras.FlyCapImageSourceOptions.ext]{serial_number:[15187914],image_width:1920,image_height:1200,sync:false}' "

alias autocam="bazel build //vehicle/sensors/cameras/autocam:autocam_test && ~/1driving/bazel-bin/vehicle/sensors/cameras/autocam/autocam_test --camera_uri '[cameras.FlyCapImageSourceOptions.ext]{serial_number:[15223367,15187914],image_width:1920,image_height:1200,sync:false}' "
alias lint="git clang-format -f; python ci/file_validators/validate.py  --fix"
alias lintall="git add --all && git clang-format -f && git add --all"
alias linthard="git add --all && git clang-format -f; python /home/bryceevans/1driving/ci/file_validators/validate.py  --fix --all && git add --all"
alias gitlist="git diff --name-only --diff-filter=U"
alias gitsl="git log --graph --full-history --all --author='Bryce Evans'"
alias gitdate="git for-each-ref --sort=committerdate refs/heads/
--format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) -
%(color:red)%(objectname:short)%(color:reset) - %(contents:subject) -
%%(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"

alias xvim="xargs bash -c '</dev/tty vim \"$@\"' ignoreme"
alias sshzimbeast="ssh -XYC zoox@kittsim02"

#wide range 16398730,16062191'
#long range 15187914,15223367

alias av='avprobe -show_streams -show_format -pretty '

alias logcam='bazel build //vehicle/sensors/cameras/logcam:logcam && ~/1driving/bazel-bin/vehicle/sensors/cameras/logcam/logcam --cam "[cameras.FlyCapImageSourceOptions.ext]{serial_number:[
15223367,15187914
],image_width:1920,image_height:1200,sync:false}" --enforce_sync=false --alsologtostderr --use_nvenc=false
--encode_file --log_artifacts --savepath /home/bryceevans/Desktop'

cammux_rolling_shutter_single()
{
  # Ensure rosparam is defined.
  bb //bin:rosparam;
  source scripts/shell/zooxrc.sh;
  rosparam delete /session_metadata/;

  # Set rosparams.
  rosparam set /cameras/camera1/serial "0587290900090706";
  rosparam set /cameras/camera1/name north_wide_left;
  rosparam set /session_metadata/time/secs 1;
  rosparam set /session_metadata/time/nsecs 100000;
  rosparam set /session_metadata/log_id $(random-string);

  echo -e "\nLOG ID: $(rosparam get /session_metadata/log_id)\n";
 bazel build //vehicle/sensors/cameras/cammux:cammux_main \
  && (cd  bazel-bin/vehicle/sensors/cameras/cammux/cammux_main.runfiles/zoox;
../../cammux_main \
--enforce_sync=false \
--alsologtostderr \
--use_nvenc=true \
--encode_file  \
--ros_publish \
--log_raw \
--log_raw_period_ms 500 \
--log_artifacts \
--savepath /home/bryceevans/Desktop \
--alsologtostderr \
--cam '[cameras.V4LImageSourceOptions.ext]{serial_number_str:["0587290900090706"],image_width:1920,image_height:1204,sync:false}';);
}


cammux_rolling_shutter()
{
  # Ensure rosparam is defined.
  bb //bin:rosparam;
  source scripts/shell/zooxrc.sh;
  rosparam delete /session_metadata/;

  # Set rosparams.
  rosparam set /cameras/camera1/serial "0587290900090706";
  rosparam set /cameras/camera2/serial "0586201E00090706";
  rosparam set /cameras/camera1/name north_wide_left;
  rosparam set /cameras/camera2/name north_wide_right;
  rosparam set /session_metadata/time/secs 1;
  rosparam set /session_metadata/time/nsecs 100000;
  rosparam set /session_metadata/log_id $(random-string);

  echo -e "\nLOG ID: $(rosparam get /session_metadata/log_id)\n";
 bazel build //vehicle/sensors/cameras/cammux:cammux_main \
  && (cd  bazel-bin/vehicle/sensors/cameras/cammux/cammux_main.runfiles/zoox;
../../cammux_main \
--enforce_sync=false \
--alsologtostderr \
--use_nvenc=true \
--encode_file  \
--ros_publish \
--log_raw \
--log_raw_period_ms 500 \
--log_artifacts \
--savepath /home/bryceevans/Desktop \
--alsologtostderr \
--cam '[cameras.V4LImageSourceOptions.ext]{serial_number_str:["0587290900090706","0586201E00090706"],image_width:1920,image_height:1204,sync:false}';);
}


cammux ()
{
  rosparam delete /session_metadata/;
  rosparam set /cameras/camera1/serial 15223367;
  rosparam set /cameras/camera2/serial 15187914;
  rosparam set /cameras/camera1/name north_wide_left;
  rosparam set /cameras/camera2/name north_wide_right;
  rosparam set /session_metadata/time/secs 1;
  rosparam set /session_metadata/time/nsecs 100000;
  rosparam set /session_metadata/log_id $(random-string);
  echo -e "\nLOG ID: $(rosparam get /session_metadata/log_id)\n";
 bazel build //vehicle/sensors/cameras/cammux:cammux_main --copt -Wno-unused-variable\
  && (cd  ~/3driving/bazel-bin/vehicle/sensors/cameras/cammux/cammux_main.runfiles/zoox;
../../cammux_main \
--enforce_sync=true \
--alsologtostderr \
--use_nvenc=true \
--encode_file  \
--ros_publish \
--log_raw \
--log_artifacts \
--savepath /home/bryceevans/Desktop \
--alsologtostderr \
--cam '[cameras.FlyCapImageSourceOptions.ext]{serial_number:[15223367,15187914],image_width:1920,image_height:1200,sync:true}';);
}

alias set_rosparams="
  echo 'setting ros params...';
  brun //vehicle/launch:vehicle_params_launch;
  rosparam set /cameras/camera1/serial 15223367;
  rosparam set /cameras/camera2/serial 15187914;
  rosparam set /session_metadata/time/secs 1;
  rosparam set /session_metadata/time/nsecs 100000;
"

alias runvision="brun -- //vehicle/sensors/cameras/image_pipeline:vision_service_cli on --machine 2"

export ZOOX_ROBOT_NAME="kitt_02"
alias gitpull="git pull origin master"
alias setupscript="pushd ~/1driving; ./scripts/setup/setup.sh dev; popd";
alias killros="pkill -f ros;"
alias runroscore="bazel build //bin:roscore; roscore;"
alias rosserver="killros; runroscore; set_rosparams;"
alias fixme="killros; gitpull; bazel clean --expunge; setupscript"

# Replace instance in directory
# find ./ -type f -exec sed -i -e 's/apple/orange/g' {} \;

alias verifylmdb="for x in ~/Documents/data/.lmdb; do brun \
labeling/lt2d:vis_lmdb_data -- -i $x -c; done"

alias aws_data="aws s3 mycommand s3://zoox-testdata/vision/datasets/kitt/detection/"

alias sshlabeling="ssh -i /home/bryceevans/.ssh/aws_mturk.pem ubuntu@ec2-52-53-128-233.us-west-1.compute.amazonaws.com"
alias sshaws="ssh -i ~/.aws/VPNServer.pem ubuntu@ec2-52-53-128-233.us-west-1.compute.amazonaws.com"

alias pipedream="ssh -i /home/bryceevans/.pipedream/bryceevans.key bryceevans@slurm-primary.zooxlabs.com"

# brun --config=cuda -c opt vision/detection/tools:detection_evaluator_main --
 #--detection_evaluator_options_file
 #/mnt/flashblade/sarah/evaluator_file_cars_inpedcarsbikestl.pbtxt
 #--annotated_image_lmdb /tmp/detector_12bit.lmdb --pr_curve
 #/tmp/pr_curve_12.txt --html /tmp/results_12.html --alsologtostderr


 alias flash="pushd /mnt/flashblade/bae/"
 alias back="popd"

 #### commands to get data for tracker

# train data
# find  /mnt/flashblade/vision_tracking/tracking/ -name 10hz | xargs cp  -t /mnt/flashblade/bae/tracker/training/logs/ -i

# test data
# find  /mnt/flashblade/vision_tracking/tracking/ -not -name 10hz | tail -10 | xargs cp -t /mnt/flashblade/bae/tracker/test/logs/ -i

# process and format
# bazel run experimental/bae/tools/tracker:gen_training  -- --in_path /mnt/flashblade/bae/tracker/test/logs --out_path /mnt/flashblade/bae/tracker/test/test.lmdb --alsologtostderr

# run model
#  bazel-bin/third_party/caffe/caffe_tool train -solver /mnt/flashblade/bae/tracker/config/solver.pbtxt --alsologtostderr=1

# plot realtime
#  while :; do echo "hello"; sleep 1; python plot_caffe_accuracy.py --input  ~/.log/glog/caffe_tool.INFO; done

plotcaffe() {
while :; do
  echo "plotting...";
  sleep 1;
  python ~/plot_caffe_accuracy.py --input  ~/.log/glog/caffe_tool.INFO;
done;
}

plotembeddingresults() {
while :; do
  echo "plotting...";
  sleep 1;
  python ~/1driving/experimental/bae/scripts/plots/plot_embedding_results.py --input  ~/.log/glog/caffe_tool.INFO;
done;
}

# takes input log id and writes a detection and question lmdb to /tmp
run_to_embedding_qs() {
  if test "$#" -ne 1; then
    echo "No log ID given"
  fi
  log_id=$1

  pushd ~/1driving;
  detection_lmdb="/tmp/${log_id}-detection.lmdb";
  pair_lmdb="/tmp/${log_id}-matched_pairs.lmdb";

  rm $detection_lmdb;
  rm $pair_lmdb;
  brun experimental/vasiliy/postmortem:run_to_pairs -- \
    --run_id ${log_id} \
    --output_ai_lmdb   ${detection_lmdb} \
    --output_qu_lmdb ${pair_lmdb} \
    --alsologtostderr=1;

  qs_lmdb="/tmp/${log_id}_qs.lmdb";
  out_html="/tmp/${log_id}_qs.html";
  brun //vision/embedding/tools:compute_pair_questions -- \
    --detection_lmdb ${detection_lmdb} \
    --pair_lmdb ${pair_lmdb} \
    --lmdb  ${qs_lmdb} \
    --html  ${out_html};



#  patch_embeddings_lmdb="/tmp/patch_embeddings_lmdb";
#  rm $patch_embeddings_lmdb;
#  bazel run //vision/embedding/tools:compute_embeddings -- \
#    --patch_embedding_pbtxt ~/2driving/experimental/bae/tools/patch_embedding_options.pbtxt \
#    --detection_lmdb $detection_lmdb \
#    --label_ids  "1003,2000,2001" \
#    --lmdb $patch_embeddings_lmdb \
#    --html_num_samples 200 \
#    --html /tmp/patch_embeddings.html;
#
#  pairs_lmdb="/tmp/pairs.lmdb";
#  rm $pairs_lmdb;
#
#    bazel run //vision/embedding/tools:compute_pairs -- --embedding_lmdb \
#  $patch_embeddings_lmdb --lmdb  $pairs_lmdb \
#  --label_num_pairs "1003:50,2000:30,2001:120";
#  # for golden questions, filter to smaller sets
#  # 1003: pedestrian, 2000: bikes, 2001: vehicles (cap all to 20,000 examples).
#
# output_qs="/tmp/pair_qs.lmdb";
# rm $output_qs;
# bazel run vision/embedding/tools:compute_pair_questions -- \
#   --detection_lmdb $detection_lmdb \
#   --pair_lmdb  $pairs_lmdb \
#   --lmdb $output_qs \
#   --html /tmp/log_to_embedding.html;
#
  aws s3 cp $output_qs s3://zoox-testdata/bae/${log_id}_qs.lmdb;

  popd;
}

process_set() {
  log_ids=(
20180104T035028-kitt_01
20180102T193050-kitt_07
20180103T223815-kitt_02
20180103T215117-kitt_03
20180103T221510-kitt_02
20171229T191712-kitt_03
20171229T194829-kitt_03
20171229T204509-kitt_03
20171229T204509-kitt_03
20171229T211838-kitt_03
20171229T224217-kitt_08
  )

#  for log_id in "${log_ids[@]}"
#  do
#    echo "Creating Qs for log: ${log_id}"
#    run_to_embedding_qs ${log_id};
#  done
#
  echo "Merging all..."
  mkdir -p /tmp/merged;
  rm -rf /tmp/merged/*;

  qs_list=""
  detections_list=""
  for log_id in "${log_ids[@]}"
  do
    if [ -f /tmp/${log_id}_qs.lmdb ]; then
      qs_list="${qs_list}/tmp/${log_id}_qs.lmdb,";
      detections_list="${detections_list}/tmp/${log_id}-detection.lmdb,";
    else
      echo "${log_id} NOT FOUND";
    fi
  done

  echo "Qs: $qs_list";
  echo $detections_list;
  pushd /home/bryceevans/1driving/;
  bazel run experimental/bae/tools/lmdb:merge_lmdbs -- --lmdbs ${qs_list} --output /tmp/merged/merged_qs.lmdb;
  bazel run experimental/bae/tools/lmdb:merge_lmdbs -- --lmdbs ${detections_list} --output /tmp/merged/detection_qs.lmdb;
  echo "Done!";
  popd;
}

ssh_embeddings_annotator() {
  ssh -i ~/.aws/VPNServer.pem ubuntu@ec2-52-53-128-233.us-west-1.compute.amazonaws.com;
}

deploy_embeddings_server() {
  pushd ~/1driving;
  fab -f vision/embedding/annotator/embedding_annotator_main.py deploy;
  popd;
}
run_tracker_metrics(){
brun //vision/tracking/scripts:run_tracking_evaluation -- --suite everything  --write_video;
}

# bazel run //vehicle/launch:vehicle_params_launch


# bazel run //vision/embedding/tools:compute_embeddings --
# --patch_embedding_pbtxt ~/2driving/patch_embedding_options.pbtxt
# --detection_lmdb
# /mnt/flashblade/vasiliy/TRG-58930@1509770961.53-detection.lmdb --label_ids
# 2001 --lmdb /mnt/flashblade/bae/patch_embeddings.lmdb  --html_num_samples 200
#      --html /mnt/flashblade/bae/patch_embeddings.html


#  bazel run //vision/embedding/tools:compute_pairs -- --embedding_lmdb
#  /mnt/flashblade/bae/patch_embeddings.lmdb --lmdb
#  /mnt/flashblade/bae/pairs.lmdb --label_num_pairs "2001:100"


# bazel run vision/embedding/tools:compute_pair_questions -- --detection_lmdb
# /mnt/flashblade/vasiliy/TRG-58930@1509770961.53-detection.lmdb --pair_lmdb
# /mnt/flashblade/bae/pairs.lmdb --lmdb /mnt/flashblade/bae/questions.lmdb
# --html /mnt/flashblade/bae/out.html
