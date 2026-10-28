@echo off
setlocal

cd /d "%~dp0"
call mvn -B -ntp clean verify
if errorlevel 1 exit /b 1

if not exist dist mkdir dist
copy /Y target\hello.jar dist\hello.jar >nul
if errorlevel 1 exit /b 1

if defined JAVA_HOME (
  "%JAVA_HOME%\bin\java" -jar dist\hello.jar
) else (
  java -jar dist\hello.jar
)
if errorlevel 1 exit /b 1
exit /b 0
