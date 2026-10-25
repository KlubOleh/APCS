#!/usr/bin/env bash
# Перевірка проєкту. Нічого не змінює (окрім target/ та dist/ при --full).
# Використання: bash scripts/check.sh [--full]
cd "$(dirname "$0")/.." || exit 1

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
for c in git-init create-project create-build create-actions check init; do
  F=.github/prompts/$c.prompt.md
  has_file "$F" && CNT=$((CNT+1))
done
[ "$CNT" -ge 6 ] && ok "команд: $CNT" || fail "команд лише $CNT (потрібно 6)"
# Порядок викликів в init
ORDER=$(grep -oE '(git-init|create-project|create-build|create-actions|check)\.prompt\.md' .github/prompts/init.prompt.md | sed 's/\.prompt\.md//' | awk '!s[$0]++' | tr '\n' ' ')
[ "$ORDER" = "git-init create-project create-build create-actions check " ] \
  && ok "init: порядок викликів правильний" || fail "init: неправильний порядок ($ORDER)"

echo "== 4. Проєкт =="
J=src/main/java/com/example/hello
T=src/test/java/com/example/hello
for f in pom.xml $J/Main.java $J/MathUtils.java $T/BasicAdditionTest.java ci.sh ci.bat README.md docs/architecture.md docs/usage.md; do has_file "$f"; done
has_text $T/BasicAdditionTest.java 'BasicAddition' "тест BasicAddition"
has_text $J/Main.java 'Hello, World!' "рядок Hello, World!"
has_text pom.xml 'junit-jupiter' "залежність JUnit 5"
has_text pom.xml 'maven-surefire-plugin' "плагін surefire"

echo "== 5. Workflow =="
W=.github/workflows/ci.yml
has_file "$W"
if python3 -c "import yaml,sys; yaml.safe_load(open('$W'))" 2>/dev/null; then ok "YAML валідний"; else fail "YAML невалідний"; fi
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
if [ "$FAILS" -eq 0 ]; then echo "РЕЗУЛЬТАТ: УСПІХ"; exit 0; else echo "РЕЗУЛЬТАТ: ПОМИЛКА ($FAILS)"; exit 1; fi
