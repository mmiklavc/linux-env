function create_project() {
    mvn archetype:create -DgroupId=$1 -DartifactId=$2 -DarchetypeArtifactId=maven-archetype-quickstart
}

function create_mvn_archetype() {
    if [ "$#" -ne "2" ]
    then
        echo "Usage: $FUNCNAME group_id artifact_id"
        return 1
    fi
    mvn archetype:generate \
        -DgroupId=$1 \
        -DartifactId=$2 \
        -DarchetypeArtifactId=maven-archetype-archetype
}

function create_hadoop_bootstrap() {
    mvn archetype:generate \
        -DarchetypeGroupId=com.michaelmiklavcic \
        -DarchetypeArtifactId=hadoop-bootstrap-archetype \
        -DarchetypeVersion=1.0-SNAPSHOT
}

function regen_eclipse() {
    mvn eclipse:eclipse -DdownloadSources -DdownloadJavadocs
}

function jpg2pdf() {
    if [ "$#" -ne "2" ]
    then
        echo "Usage: $FUNCNAME jpeg-image pdf-outfile-name"
        return 1
    fi
    sips -s format pdf $1 --out $2
}

function push_to() {
    if [ -z "$1" ]
    then
        echo "Usage: $FUNCNAME scp_target"
        return 1
    fi
    mvn package && scp target/*.jar $1
}

# create an executable shell script
function mkshellscript() {
    if [ -z "$1" ]
    then
        echo "Need more cowbell - script name missing, boss ;-P"
        return 1
    fi
    local fileName=${1}.sh
    touch $fileName
    chmod ug+x $fileName
    # keep the lack of indentation below to ensure the file
    cat << 'EOF' > $fileName
#!/bin/bash

pushd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" > /dev/null

echo "Running..."
echo "Done running"

popd > /dev/null

EOF
}

# Display users
function dusers() {
    awk -F":" '{ printf "uname: %-12s uid: %s\n", $1, $3 }' /etc/passwd | sort
}

# Display groups
function dgroups() {
    cut -d: -f1 /etc/group | sort
}

function portservice() {
    local portNum=$1
    if [[ -z $portNum ]]; then
        echo "Port num missing"
        return 1
    fi
    local portMatch=$(netstat -npl | grep -i $portNum)
    echo $portMatch
    ps aux | grep -i $(echo $portMatch | awk '{ print $7 }' | grep -i -o ^[^\/]*)
}

function serviceport() {
    local service=$1
    if [[ -z $service ]]; then
        echo "Expected service name missing"
        return 1
    fi
    local PID=$(ps -ef | grep -i $service | awk 'NR==1 { print $2 }')
    echo "PID=$PID"
    netstat -npl | grep -i $PID
}

# change to ancestor directory
# /hadoop/storm/nimbus/inbox
# cdp storm
# /hadoop/storm
function cdp() {
    match=$1
    newDir=${PWD%${match}*}${match}
    cd $newDir
}

# Uncomment for color on Mac OSX
#alias ls="ls -G"
alias ll="ls -l"
alias l1="ls -1"
alias la="ls -Al"
alias grep="grep --color=auto"

set -o vi

## ENV VARS ##

# Uncomment for Mac OSX - hostname does not take --ip-address arg
#export PS1="\[\e[1;33\]m[\\u: \\w]\\n\\$\[\e[m\] "
export PS1="\[\e[1;33\]m[\\u@\\h($(hostname --ip-address)): \\w]\\n\\$\[\e[m\] "

## HADOOP
export OOZIE_URL=http://localhost:11000/oozie
export FALCON_URL=http://localhost:15000

# Eternal bash history. - http://stackoverflow.com/a/19533853/3236723
# ---------------------
# Undocumented feature which sets the size to "unlimited". (I'm not using unlimited for the file, but setting it high)
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=100000
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
