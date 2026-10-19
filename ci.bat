@echo off
setlocal
echo == Java / Maven ==
java -version
if errorlevel 1 exit /b 1
call mvn -version
if errorlevel 1 exit /b 1
echo == Build + test ==
call mvn -B -ntp clean verify
if errorlevel 1 exit /b 1
echo == Check artifact ==
if not exist build\hello.jar (echo hello.jar not found & exit /b 1)
echo == Run ==
java -jar build\hello.jar
if errorlevel 1 exit /b 1
echo CI OK
exit /b 0
