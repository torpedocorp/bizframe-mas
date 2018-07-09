#!/bin/sh
# --------------------------------------------------------------
#  Start script for BizFrame MAS platform
#  Torpedo corp.
# --------------------------------------------------------------

# ------------------------------------------------------
# JAVA_HOME=
# MAS_HOME=
# ----------------------------------------------------------

MAS_HOME=../

MAS_CLASSPATH=$MAS_HOME/bin/bizframe-mas-command-2.0.0.jar


echo Start BizFrame MAS command tool 
echo JAVA_HOME : $JAVA_HOME
echo PRODUCT_HOME : $MAS_HOME

if [ -z "$JAVA_HOME" ]; then
	echo define JAVA_HOME variable.
	exit 1
fi

$JAVA_HOME/bin/java -classpath $MAS_CLASSPATH kr.co.bizframe.mas.command.cli.CommandMain 


