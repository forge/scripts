#!/bin/sh
 : ${1:?"Must specify release version. Ex: 2.0.1.Final"}
 : ${2:?"Must specify next development version. Ex: 2.0.2-SNAPSHOT"}

if [ -f "$HOME/.profile" ]
then
   . $HOME/.profile
fi

function release_furnace {
        REL=$1
        DEV=$2
        REPO=$3
        REPODIR=$4
        git clone $REPO $REPODIR
        cd $REPODIR
        echo Releasing \"$REPO\" - $1 \(Next dev version is $2\)
        mvn release:prepare release:perform \
                -DdevelopmentVersion=$DEV \
                -DreleaseVersion=$REL \
                -Dtag=$REL \
                -Darguments=-DskipTests \
                -Dversion.furnace=$REL
        cd ..
}

WORK_DIR=`mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir'`
echo "Working in temp directory $WORK_DIR"
cd $WORK_DIR
release_furnace $1 $2 git@github.com:forge/furnace.git furnace
release_furnace $1 $2 git@github.com:forge/furnace-simple.git furnace-simple
release_furnace $1 $2 git@github.com:forge/furnace-cdi.git furnace-cdi
xdg-open https://repository.jboss.org/nexus/index.html
echo "Cleaning up temp directory $WORK_DIR"
rm -rf $WORK_DIR
