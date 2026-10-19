---
mode: agent
agent: build-engineer
description: Створює GitHub Actions workflow ci.yml через skill github-actions.
---
# create-actions
**Передумови:** існують `ci.sh` і `ci.bat`.

**Дії:** застосуй skill `github-actions`.

**Очікувані файли:** `.github/workflows/ci.yml`.
**Перевірка:** YAML валідний; є ubuntu/windows/macos; тригери push та pull_request; немає прямих викликів `mvn` і `secrets`.
**Помилка:** якщо відсутні скрипти — зупинись і запропонуй виконати `create-build`.
