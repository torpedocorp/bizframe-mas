#!/bin/sh
# --------------------------------------------------------------
# Start script for BizFrame MAS platform
# Torpedo corp.
# --------------------------------------------------------------


#------------------------------------------------------
# JAVA_HOME=
# MAS_HOME=
#----------------------------------------------------------

MAS_HOME=../
JAVA_OPTS=' -Xms128M -Xmx256M'  

MAS_CLASSPATH=$MAS_HOME/bin/boot.jar


echo Start BizFrame MAS platform
echo JAVA_HOME : $JAVA_HOME
echo PRODUCT_HOME : $MAS_HOME


if [ $1 = "start" ]; then
  CMD_LINE_ARGS=$1
elif   [ $1 = "run" ]; then
  CMD_LINE_ARGS="start"
elif [ $1 = "shutdown" ]; then
  CMD_LINE_ARGS=$1
fi


if [ -z "$JAVA_HOME" ]; then
	echo define JAVA_HOME variable.
	exit 1
fi

if [ $1 = "start" ]; then
$JAVA_HOME/bin/java -classpath $MAS_CLASSPATH kr.co.bizframe.mas.boot.Main $CMD_LINE_ARGS &
else
$JAVA_HOME/bin/java -classpath $MAS_CLASSPATH kr.co.bizframe.mas.boot.Main $CMD_LINE_ARGS
fi

