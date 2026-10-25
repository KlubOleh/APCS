#!/usr/bin/env bash
# Перевірка проєкту. Нічого не змінює (окрім target/ та dist/ при --full).
# Використання: bash scripts/check.sh [--full]
PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)" || {
  echo "[FAIL] не вдалося визначити корінь проєкту зі шляху scripts/check.sh" >&2
  return 1 2>/dev/null || exit 1
}
cd "$PROJECT_ROOT" || {
  echo "[FAIL] не вдалося перейти до кореня проєкту: $PROJECT_ROOT" >&2
  return 1 2>/dev/null || exit 1
}

FAILS=0
ok()   { echo "[OK]   $1"; }
fail() { echo "[FAIL] $1"; FAILS=$((FAILS+1)); }
has_file() { [ -f "$1" ] && ok "файл $1" || fail "відсутній файл $1"; }
has_text() { grep -qE -- "$2" "$1" 2>/dev/null && ok "$1: $3" || fail "$1: немає '$3'"; }

echo "== 1. Manifest =="
M=.github/agents/build-engineer.agent.md
has_file "$M"
has_text "$M" '^## Роль' "розділ Роль"
has_text "$M" '^## Заборонені дії' "розділ Заборонені дії"
has_text "$M" '^## Критерії успішного завершення' "розділ Критерії завершення"

echo "== 2. Skills =="
for s in project-scaffold build-and-test github-actions; do
  F=.github/skills/$s/SKILL.md
  has_file "$F"
  for sec in "Призначення" "Вхідні дані" "Вихідні дані" "Перевірки" "Типова помилка"; do
    has_text "$F" "^## $sec" "розділ $sec"
  done
done

echo "== 3. Commands =="
CNT=0
for c in git-init create-project create-build create-actions check init-project; do
  F=.github/prompts/$c.prompt.md
  has_file "$F" && CNT=$((CNT+1))
done
[ "$CNT" -ge 6 ] && ok "команд: $CNT" || fail "команд лише $CNT (потрібно 6)"
# Порядок викликів в init-project
ORDER=$(grep -oE '(git-init|create-project|create-build|create-actions|check)\.prompt\.md' .github/prompts/init-project.prompt.md | sed 's/\.prompt\.md//' | awk '!s[$0]++' | tr '\n' ' ')
[ "$ORDER" = "git-init create-project create-build create-actions check " ] \
  && ok "init-project: порядок викликів правильний" || fail "init-project: неправильний порядок ($ORDER)"

echo "== 4. Проєкт =="
J=src/main/java/com/example/hello
T=src/test/java/com/example/hello
for f in pom.xml $J/Main.java $J/MathUtils.java $T/BasicAdditionTest.java ci.sh ci.bat README.md docs/architecture.md docs/usage.md; do has_file "$f"; done
has_text $T/BasicAdditionTest.java 'BasicAddition' "тест BasicAddition"
has_text $J/Main.java 'Hello, World!' "рядок Hello, World!"
has_text pom.xml 'junit-jupiter' "залежність JUnit 5"
has_text pom.xml 'maven-surefire-plugin' "плагін surefire"

echo "== Перевірка Java =="
if [ -n "${JAVA_HOME:-}" ]; then
  JAVA_CMD="$JAVA_HOME/bin/java"
  JAVA_SOURCE="JAVA_HOME"
else
  JAVA_CMD=java
  JAVA_SOURCE="PATH"
fi
if [ "$JAVA_CMD" = java ] && ! command -v java >/dev/null 2>&1; then
  fail "Java не знайдено в PATH; встановіть JDK 17+ або задайте JAVA_HOME"
elif [ "$JAVA_CMD" != java ] && [ ! -x "$JAVA_CMD" ]; then
  fail "java не знайдено або не запущено з JAVA_HOME ($JAVA_HOME); задайте JAVA_HOME на JDK 17+"
elif JAVA_VERSION_OUTPUT=$("$JAVA_CMD" -version 2>&1); then
  JAVA_VERSION=$(printf '%s\n' "$JAVA_VERSION_OUTPUT" | awk -F '"' '/version/ { if (NF >= 2) { print $2; exit } }')
  if [ -z "$JAVA_VERSION" ]; then
    fail "не вдалося визначити версію Java з виводу '$JAVA_CMD -version'"
  else
    case "$JAVA_VERSION" in
      1.*) JAVA_MAJOR=${JAVA_VERSION#1.}; JAVA_MAJOR=${JAVA_MAJOR%%.*} ;;
      *) JAVA_MAJOR=${JAVA_VERSION%%.*} ;;
    esac
    if [[ ! "$JAVA_MAJOR" =~ ^[0-9]+$ ]]; then
      fail "не вдалося визначити основну версію Java з '$JAVA_VERSION'"
    elif [ "$JAVA_MAJOR" -lt 17 ]; then
      fail "потрібна Java 17+, знайдено Java $JAVA_VERSION ($JAVA_SOURCE); налаштуйте JAVA_HOME або PATH"
    else
      ok "Java $JAVA_VERSION ($JAVA_SOURCE)"
    fi
  fi
else
  printf '%s\n' "$JAVA_VERSION_OUTPUT" >&2
  fail "не вдалося запустити Java через $JAVA_SOURCE; встановіть JDK 17+ і перевірте JAVA_HOME або PATH"
fi

echo "== 5. Workflow =="
W=.github/workflows/ci.yml
has_file "$W"
PYTHON_CMD=()
PYTHON_LABEL=
for candidate in python3 python py; do
  command -v "$candidate" >/dev/null 2>&1 || continue
  if [ "$candidate" = py ]; then
    candidate_cmd=(py -3)
  else
    candidate_cmd=("$candidate")
  fi
  if "${candidate_cmd[@]}" -c 'import sys; sys.exit(0 if sys.version_info[0] == 3 else 1)' >/dev/null 2>&1; then
    PYTHON_CMD=("${candidate_cmd[@]}")
    PYTHON_LABEL="$candidate"
    break
  fi
done
if [ "${#PYTHON_CMD[@]}" -eq 0 ]; then
  fail "Python 3 не знайдено або він недоступний (перевірено python3, python, py -3)"
elif ! "${PYTHON_CMD[@]}" -c 'import yaml'; then
  fail "не знайдено модуль Python yaml (PyYAML) для $PYTHON_LABEL; встановіть PyYAML у вибране середовище"
elif CI_WORKFLOW="$W" "${PYTHON_CMD[@]}" -c 'import os, yaml; yaml.safe_load(open(os.environ["CI_WORKFLOW"], encoding="utf-8"))'; then
  ok "YAML валідний (UTF-8, Python: $PYTHON_LABEL)"
else
  fail "YAML невалідний; див. повідомлення парсера вище"
fi
for os in ubuntu-latest windows-latest macos-latest; do has_text "$W" "$os" "ОС $os"; done
if grep -E '^\s*run:' "$W" | grep -qiE 'mvn|javac|java '; then fail "workflow містить прямі виклики mvn/javac"; else ok "workflow викликає лише скрипти"; fi
if grep -qiE 'secrets\.|token|password' "$W"; then fail "у workflow знайдено секрети"; else ok "секретів у workflow немає"; fi

echo "== 6. Git та .gitignore =="
has_text .gitignore '^target/' "target/ в .gitignore"
has_text .gitignore '^dist/' "dist/ в .gitignore"
if git rev-parse --git-dir >/dev/null 2>&1; then
  if [ -n "$(git ls-files target build dist 2>/dev/null)" ]; then fail "target/ або dist/ відстежуються Git"; else ok "target/ і dist/ не під Git"; fi
  if git ls-files | grep -qE '(^|/)\.env$|\.pem$|\.key$'; then fail "у Git є файли секретів"; else ok "секретів у Git немає"; fi
else
  echo "[SKIP] не Git-репозиторій"
fi

if [ "${1:-}" = "--full" ]; then
  echo "== 7. Складання та тести =="
  if bash ./ci.sh > /tmp/ci_out.log 2>&1; then
    ok "ci.sh завершився успішно"
    grep -q 'BasicAdditionTest' /tmp/ci_out.log && grep -qE 'Tests run: 1, Failures: 0, Errors: 0' /tmp/ci_out.log && ok "JUnit виконав BasicAddition (Tests run: 1, 0 помилок)" || fail "BasicAddition не пройшов або не запускався"
    grep -q 'Hello, World!' /tmp/ci_out.log && ok "hello вивів Hello, World!" || fail "hello не вивів Hello, World!"
  else
    fail "ci.sh завершився з помилкою (див. вивід нижче)"; tail -n 20 /tmp/ci_out.log
  fi
fi

echo
if [ "$FAILS" -eq 0 ]; then
  echo "РЕЗУЛЬТАТ: УСПІХ"
  RESULT=0
else
  echo "РЕЗУЛЬТАТ: ПОМИЛКА ($FAILS)"
  RESULT=1
fi
return "$RESULT" 2>/dev/null || exit "$RESULT"
