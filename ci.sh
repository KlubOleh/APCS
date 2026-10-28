#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
mvn -B -ntp clean verify
mkdir -p dist
cp target/hello.jar dist/hello.jar
if [[ -n "${JAVA_HOME:-}" ]]; then
  JAVA="$JAVA_HOME/bin/java"
else
  JAVA=java
fi
"$JAVA" -jar dist/hello.jar
