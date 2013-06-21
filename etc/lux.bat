echo off
set LUX_HOME=.
echo LUX_HOME=%LUX_HOME%
if "%1"=="stop" (
  java -jar start.jar -DSTOP.PORT=8881 -DSTOP.KEY=magic --stop
  exit /b
)
if "%1"=="restart" (
  java -jar start.jar -DSTOP.PORT=8881 -DSTOP.KEY=magic --restart
  exit /b
)
if "%1"=="start" (
 java -jar start.jar -Xmx1024m -Dorg.expath.pkg.saxon.repo=%LUX_HOME%/xrepo -DSTOP.PORT=8881 -DSTOP.KEY=magic --daemon
  exit /b
)
if "%1"=="" (
 start java -jar start.jar -Xmx1024m -Dorg.expath.pkg.saxon.repo=%LUX_HOME%/xrepo -DSTOP.PORT=8881 -DSTOP.KEY=magic --daemon
  exit /b
)
echo "usage: lux [start | restart | stop]"

