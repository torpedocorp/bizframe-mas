@echo off
rem --------------------------------------------------------------
rem  Start script for BizFrame MAS platform
rem  Torpedo corp.
rem --------------------------------------------------------------

rem ------------------------------------------------------
rem SET JAVA_HOME=
rem SET MAS_HOME=
rem ----------------------------------------------------------


SET MAS_HOME= ../
SET JAVA_OPTS= -Xms128m -Xmx256m  

SET MAS_CLASSPATH=%MAS_HOME%\bin\boot.jar

if ""%1"" == ""start"" set CMD_LINE_ARGS=%1
if ""%1"" == ""shutdown"" set CMD_LINE_ARGS=%1

echo Start BizFrame MAS platform
echo JAVA_HOME : %JAVA_HOME%
echo PRODUCT_HOME : %MAS_HOME%

if exist "%JAVA_HOME%"  goto okJAVA
echo define exact JAVA_HOME variable.
goto end
: okJAVA

SET _RUNJAVA="%JAVA_HOME%/bin/java"
%_RUNJAVA% -classpath %MAS_CLASSPATH% %JAVA_OPTS% kr.co.bizframe.mas.boot.Main %CMD_LINE_ARGS%

:end