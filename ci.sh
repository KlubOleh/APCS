#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
mvn -B -ntp clean verify
mkdir -p dist
cp target/hello.jar dist/hello.jar
java -jar dist/hello.jar
