#!/usr/bin/env bash
set -euo pipefail

echo "== Java / Maven =="
java -version
mvn -version

echo "== Build + test =="
mvn -B -ntp clean verify

echo "== Check test report =="
grep -q 'name="BasicAddition"' build/surefire-reports/TEST-*.xml

echo "== Check artifact =="
test -f build/hello.jar

echo "== Run =="
OUT="$(java -jar build/hello.jar)"
echo "$OUT"
[ "$OUT" = "Hello, World!" ]

echo "CI OK"
