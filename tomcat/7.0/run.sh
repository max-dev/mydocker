#!/bin/bash

function usage()
{
 echo "Run a war into a tomcat 7 container"
 echo "Usage : $0 <path to a war>"
 exit 1
}

function findAndBuildDocker()
{
 docker images | grep "$1" > /dev/null || docker build -t "$1" .
}

findAndBuildDocker tomcat7

if [ "$1" == "" ];
then
 usage
fi

WAR=$(readlink -f "$1")

if [ ! -r "$WAR" ];
then
 echo "Impossible to read $WAR"
 usage
fi

TEMPDIR=$(mktemp -d)

cp "$WAR" "$TEMPDIR"


CONTAINER_ID=$(docker run -d -P -v="$TEMPDIR":/var/lib/tomcat7/webapps tomcat7)
PORT=$(docker port $CONTAINER_ID 8080 | cut -d ":" -f 2)

echo "\nTomcat 7 running on local post $PORT"
echo "To stop : "
echo "docker stop $CONTAINER_ID && rm -rf $TEMPDIR"
