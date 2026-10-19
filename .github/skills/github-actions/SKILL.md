---
name: github-actions
description: Створює .github/workflows/ci.yml з matrix ubuntu/windows/macos, що запускає лише ci.sh/ci.bat. Використовуй для налаштування CI.
---

# Коли застосовувати
Для команди `create-actions`; після `create-build`.

# Вхідні дані
Наявні `ci.sh`, `ci.bat`; гілки `develop`, `master`.

# Дії
1. Створи/онови `.github/workflows/ci.yml`:
   - тригери `push` і `pull_request` на `develop`, `master`;
   - одна job `build` з `strategy.matrix.os: [ubuntu-latest, windows-latest, macos-latest]`;
   - кроки: `actions/checkout`, `actions/setup-java` (temurin 17), запуск `ci.sh` (Linux/macOS) або `ci.bat` (Windows), `actions/upload-artifact` для `build/hello.jar`.
2. Не додавай логіку складання в YAML — лише виклик скриптів.
3. Не використовуй `secrets`.

# Очікуваний результат
`.github/workflows/ci.yml`.

# Перевірки
- YAML валідний (`python -c "import yaml;yaml.safe_load(open('.github/workflows/ci.yml'))"`).
- Містить усі три ОС, `push`, `pull_request`, виклики `ci.sh`/`ci.bat`.
- Не містить `secrets.` і прямого `mvn`.

# Типова помилка
`ci.sh` без права виконання на Linux → запускай через `bash ci.sh`. Помилка відступів у YAML → виправ і повтори перевірку.
