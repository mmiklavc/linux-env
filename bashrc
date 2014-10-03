# create an executable shell script
function mkshellscript() {
    if [[ -z $1 ]]; then
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

alias ll="ls -l"
alias l1="ls -1"
alias la="ls -Al"

set -o vi

## ENV VARS ##

export PS1="\[\e[1;33\]m[\\u@\\h($(hostname --ip-address)): \\w]\\n\\$\[\e[m\] "

export OOZIE_URL=http://localhost:11000/oozie
export FALCON_URL=http://localhost:15000
