#!/bin/bash

BASE_DIR=`cd $(dirname $0)/..;pwd`

MAIN_CLASS="com.narvar.message.integrations.MessagingIntegrationsApplication"
JAR_NAME="message-integrations.jar"
while getopts j:p:l:s: option
do
    case "${option}"
    in
    j) BUILT_JAR=${OPTARG};;
    p) APPLICATION_PROPERTIES=${OPTARG};;
    l) LOG_PROPERTIES=${OPTARG};;
    esac
done

if [ -z "$JAVA_HOME" ]; then
    echo "Warning: JAVA_HOME not configured, defaulting to: $(which java)"
    JAVA="java"
else
    JAVA="$JAVA_HOME/bin/java"
fi

if [ -z "$JAVA_OPTS" ]; then
    JAVA_OPTS="-Xms256m -Xmx1800m"
fi

if [ -z "$STACK" ]; then
    STACK="dev"
fi

if [ -z "$DSTACK" ]; then
    DSTACK="qa"
fi

if [ -z "$BUILT_JAR" ]; then
    BUILT_JAR=`find $BASE_DIR"/target" -name $JAR_NAME | head -n1`
fi

if [ -z "$BUILT_JAR" ]; then
    echo "Error: Executable jar not found in '$BASE_DIR/target'
    Please run 'mvn clean package'" >> /dev/stderr
    exit 1
fi

if [ ! -z "$LOG_PROPERTIES" ]; then
    SYSTEM_OPTS="-Dlogback.configurationFile=$LOG_PROPERTIES"
fi

if [ ! -z "$APPLICATION_PROPERTIES" ]; then
    OPTS="--spring.config.location=$APPLICATION_PROPERTIES"
fi

SYSTEM_OPTS_STACK="-Dspring.profiles.active=$STACK -Dstack=$DSTACK"

CMD="$JAVA $JAVA_OPTS $SYSTEM_OPTS $SYSTEM_OPTS_STACK -jar $BUILT_JAR $MAIN_CLASS $OPTS"
echo "INFO - Command to execute: \`$CMD\`"
exec $CMD