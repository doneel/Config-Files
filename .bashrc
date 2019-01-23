#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# ============== Environment ====================

export EDITOR="nvim"
export VISUAL="nvim"
export CLUTTER VBLANK=none
alias vim='nvim'
set -o vi

# ============== History =========================
# Keep 1000 lines in .bash_history (default is 500)
export HISTSIZE=10000

# ignore commands that lead with a space, ignore dups
export HISTCONTROL=ignoreboth,ignoredups
shopt -s histappend

#Write continuously
export PROMPT_COMMAND='history -a'

# ============= Utilities ========================

# Get size of directory
dirsize() {
     sudo find . ! -name . -type d -prune -exec du -hs {} \;
}

# Easy extract
extract () {
       if [ -f $1 ] ; then
          case $1 in
               *.tar.bz2)   tar xvjf $1    ;;
               *.tar.gz)    tar xvzf $1    ;;
               *.bz2)       bunzip2 $1     ;;
               *.rar)       rar x $1       ;;
               *.gz)        gunzip $1      ;;
               *.tar)       tar xvf $1     ;;
               *.tbz2)      tar xvjf $1    ;;
               *.tgz)       tar xvzf $1    ;;
               *.zip)       unzip $1       ;;
               *.Z)         uncompress $1  ;;
               *.7z)        7z x $1        ;;
               *)           echo "don't know how to extract '$1'..." ;;
          esac
       else
          echo "'$1' is not a valid file!"
       fi
}

# Makes directory then moves into it
function mkcdr {
     mkdir -p -v $1
     cd $1
}

# Creates an archive from given directory
mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

function open {
     if command -v nautilus &> /dev/null; then
          nautilus $1
     fi
}

function shot
{
     scrot $1 -c -d 5 #-e #'%T_$wx$h_scrot.png' -c -d 5 -e #'mv $f $1'
}


#Executes the last command you run that matches a grep pattern you provide
#Written by me, pretty sweet, huh?
function prev
{
     COMMAND=`cat ~/.bash_history | grep -v "prev" | grep -v "search_history" | grep $1 | tail -1`
     eval $COMMAND
}

# =============== Alias Shortcuts =================
alias home=~/
alias Downloads=~/Downloads
alias workbench=~/workbench

# =============== Alias Command Shortcuts =========

alias lsize='ls --sort=size -lhr' # list by size
alias ff='sudo find / -name $1'
alias search_history='cat ~/.bash_history | grep -v "search_history" | grep $1'
alias sauerbraten='sauerbraten-client 2>&1 | tee -a ~/space/sauerbraten/log.txt'

# =============== i3 settings =====================
if [ -f /usr/libexec/java_home ]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi
export PATH="/usr/local/bin:$PATH"
#export AIRFLOW_HOME=/usr/local/airflow
export JOB_CONTROLLER_REPO_PATH=~/repos/job-controller
export AWS_CREDENTIALS_PATH=~/.aws/
#export SPARK_LOCAL_IP=127.0.0.1
#export DYLD_LIBRARY_PATH=/usr/lib:/usr/local/lib

set -o vi
#!/bin/bash
has_nvim=$(command -v nvim >/dev/null)
if ! $has_nvim; then
  alias vim="nvim"
fi
#alias ssh="sshrc"
bind '"fd":vi-movement-mode'

export MAVEN_OPTS="-Xmx8192m"
export HISTFILESIZE=100000

export SANTAFE_HOME=~/repos/santafe
export BASH_CONFIG_PATH=~/.bash_profile # if you are on OSX
export EVENT_NOKQUEUE=1
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
export USER_ID=8824114678724821
# bash prompt config
DEFAULT_PROMPT=$PS1
PS1="[\u@\h \t \w]\$ "
#if [ -f $SSHHOME/.sshrc.d/.vimrc ]; then
#  export VIMINIT="let \$MYVIMRC=$SSHHOME/.sshrc.d/.vimrc' | source \$MYVIMRC"
#fi

export FZF_TMUX=1
export FZF_TMUX_HEIGHT=25%
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# RipGrep and FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#usage: emr-start com.wealthfront.data.scala.my.pipeline my-cluster-name
emr-start() {
java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main push prod-emr-danielon-1.0-SNAPSHOT.jar
java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main start --jar s3://wf-data/jobs/prod-emr-danielon-1.0-SNAPSHOT.jar -c 8 -t M5_4XLARGE -s M5_4XLARGE -n $2 -m $1 -k -a "ttl=1440 id=001 generate-initial-positions"
# CLUSTER_IP=$(aws emr describe-cluster --cluster-id j-19NHWNGCEW1AZ | grep MasterPublicDnsName | grep -o "[A-z0-9\.-]*.amazonaws.com")
}

#usage: emr-step com.wealthfront.data.scala.my.pipeline j-38952FDSCK
emr-step() {
  java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main push prod-emr-danielon-1.0-SNAPSHOT.jar
  java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main step --jar s3://wf-data/jobs/prod-emr-danielon-1.0-SNAPSHOT.jar -j $2 -m $1 -a "ttl=1440 location=wf-data-test/backtest/danielon-test-1 id=2"
}

#usage: emr-start com.wealthfront.data.scala.my.pipeline my-cluster-name side-branch-build-id
emr-start-with-id() {
  ((BUILD_NUMBER_ID=$3 % 100 ))
  java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main start --jar s3://wf-data/jobs/prod-emr-1.0-SNAPSHOT-$BUILD_NUMBER_ID.jar -c 80 -t M5_4XLARGE -s M5_4XLARGE -n $2 -m $1 -k
}

emr-start-no-push() {
java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main start --jar s3://wf-data/jobs/prod-emr-danielon-1.0-SNAPSHOT.jar -c 8 -t M4_2XLARGE -s M4_2XLARGE -n $2 -m $1 -k
}

emr-start-prod-old() {
java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main push prod-emr-danielon-1.0-SNAPSHOT.jar
java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main start --jar s3://wf-data/jobs/prod-emr-danielon-1.0-SNAPSHOT.jar -c 8 -t M4_LARGE -n $2 -m $1 -k -a "with-prod-write update-sirius id=1517441519968"
}

emr-start-prod() {
java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main start --jar s3://wf-data/jobs/prod-emr-1.0-SNAPSHOT.jar -c 10 -t M4_XLARGE -s M4_2XLARGE -n $2 -m $1 -k -a "with-prod-write update-sirius --reportDate 2018-12-08"
}

#usage: emr-start com.wealthfront.data.scala.my.pipeline my-cluster-name side-branch-build-id
emr-step-with-id() {
  ((BUILD_NUMBER_ID=$3 % 100 ))
  java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main step --jar s3://wf-data/jobs/prod-emr-1.0-SNAPSHOT-$BUILD_NUMBER_ID.jar -j $2 -m $1 -a "ttl=1440"
}

emr-step-no-push() {
  java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main step --jar s3://wf-data/jobs/prod-emr-danielon-1.0-SNAPSHOT.jar -j $2 -m $1 
}

emr-step-prod-old() {
java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main push prod-emr-danielon-1.0-SNAPSHOT.jar
java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main step --jar s3://wf-data/jobs/prod-emr-danielon-1.0-SNAPSHOT.jar -j $2 -m $1 -a "with-prod-write update-sirius"
}

emr-step-prod() {
java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main step --jar s3://wf-data/jobs/prod-emr-1.0-SNAPSHOT.jar -j $2 -m $1 -a "with-prod-write update-sirius --reportDate 2018-12-08"
}

emr-step-prod-with-id() {
java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main step --jar s3://wf-data/jobs/prod-emr-1.0-SNAPSHOT-$BUILD_NUMBER_ID.jar -j $2 -m $1 -a "with-prod-write update-sirius"
}

#usage: emr-stop j-38952FDSCK
emr-stop() {
  java -classpath ~/repos/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main stop -j $1
}

switch-java8() {
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_74.jdk/Contents/Home
}

switch-java7() {
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_10.jdk/Contents/Home
}

ikq() {
  echo "$@"
  ssh danielon@glados.wlth.fr "ikq $@"
}

free() {
top -l 1 -s 0 | grep PhysMem
}

quick-build-emr() {
  mvn install -rf :prod-emr -DskipTests -Dscalastyle.skip=true -Dcheckstyle.skip=true -Dmaven.test.skip=true
}

quick-build() {
  mvn install -DskipTests -Dscalastyle.skip=true -Dcheckstyle.skip=true -Dmaven.test.skip
}

explore-avro() {
  (echo 'import com.databricks.spark.avro._;import org.apache.spark.sql.SparkSession;val spark = SparkSession.builder().master("local").getOrCreate();
  val df = spark.read.avro("./*.avro");df.createOrReplaceTempView("table");' && cat) | $SPARK_HOME/bin/spark-shell --master local[4] --packages com.databricks:spark-avro_2.11:3.0.1 --driver-memory 4g --executor-memory 4g
}

recent-branches() {
  git for-each-ref --sort=committerdate --format='%(refname:short)' refs/heads/
}

#usage: to-json wf-data/derived/clients/account_summaries_errors/daily/2018/05/09
to-json() {
  aws s3 sync s3://$1 .
  avro-tools concat ./*.avro
  avro-tools tojson $(ls -S *.avro| head -1) | tee output.json | less
}

not-yet-run() {
ssh glados.wlth.fr 'ikq ny4-srs1 GetInvocationCounts | grep -o ,.*\ 1 | sort -u | grep -v hourly'
}

get-dependency-graph() {
  ssh glados.wlth.fr 'ikq srs1 GetJobGraph' | dot -Tsvg > graph.svg
}

get-local-dependency-graph() {
  ssh glados.wlth.fr 'ikq srs1 GetLocalDependencyGraph ' $1 | dot -Tsvg > graph.svg
}

get-downstream-dependency-graph() {
  ssh glados.wlth.fr 'ikq srs1 GetDownstreamJobsGraph ' $1 | dot -Tsvg > graph.svg
}

remote-build-push() {
  tar -czf pe.tar.gz pom.xml prod-emr/pom.xml prod-emr/src/
  scp pe.tar.gz eng-aws-jenslave10.wlth.fr:'~/data-platform/pe.tar.gz'
  ssh eng-aws-jenslave10.wlth.fr '
    cd ~/data-platform/;
    tar -xvzf pe.tar.gz;
    JAVA_HOME=/usr/lib/jvm/java-1.8.0/jre/ /data/jenkins/tools/hudson.tasks.Maven_MavenInstallation/Maven-3.0.5/bin/mvn install -rf :prod-emr -DskipTests -Dscalastyle.skip=true -Dcheckstyle.skip=true;
    java -classpath ~/data-platform/prod-emr/target/prod-emr-1.0-SNAPSHOT.jar com.wealthfront.data.controller.Main push prod-emr-danielon-1.0-SNAPSHOT.jar;'
}

last-log() {
yarn logs -applicationId $(grep -ho 'application_[0-9]*_[0-9]*' -r /mnt/var/log/hadoop/steps/ | uniq | tail -1) | less
}

list-etl-processes() {
  sudo -u etl jps -lm
}

dump-csv-c() {
  PGSSLMODE=require psql -p 5439 -h redshift-proxy.wlth.fr -d readonly -U danielon -A -F"," -c "$1" > out.csv
}

dump-csv-f() {
  PGSSLMODE=require psql -p 5439 -h redshift-proxy.wlth.fr -d readonly -U danielon -A -F"," -f $1 > out.csv
}

runtimes() {
  redshift -c "select step_name, start_time, duration_seconds / 60 as minutes, instance_type, requested_instance_count from aws_step join aws_cluster_details on aws_step.cluster_id = aws_cluster_details.cluster_id where step_name like '%$1%' and requested_instance_count > 1 order by start_time desc limit 10;"
}

table-status() {
  redshift -c "select * from redshift_status where table_name like '%$1%' order by at desc limit 5;"
}

gp() {
  BRANCH=$(git rev-parse --abbrev-ref HEAD) || kill -INT $$
  if [[ "$BRANCH" == "master" ]]; then
    echo 'ur a idiot';
  else 
    git push origin HEAD;
  fi
}

barc() {
  vim ~/.bashrc && source ~/.bashrc
}

echo "Updated bashrc at $(date +"%H:%M")"
