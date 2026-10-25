---
name: github-actions
description: Створює .github/workflows/ci.yml з однією job і matrix для ubuntu, windows, macos, що лише запускає ci.sh / ci.bat. Використовуй після build-and-test.
---

# github-actions

## Призначення
Створити CI workflow, який на трьох ОС викликає скрипти складання та зберігає виконуваний файл як artifact.

## Вхідні дані
- Наявні `ci.sh` і `ci.bat` (результат `build-and-test`).
- Гілки для запуску: `develop`, `master`.

## Вихідні дані
- `.github/workflows/ci.yml`

## Правила
1. Тригери: `push` та `pull_request` для `develop` і `master`.
2. **Одна job** `build-test` з `strategy.matrix.os: [ubuntu-latest, windows-latest, macos-latest]`, `fail-fast: false`.
3. Кроки: `actions/checkout`, `actions/setup-java` (temurin 17, `cache: maven`), запуск `ci.sh` (Linux/macOS, `shell: bash`) або `ci.bat` (Windows, `shell: cmd`), `actions/upload-artifact` для `dist/`.
4. Уся логіка складання лише у скриптах. У workflow заборонені прямі виклики `mvn`, `javac`, `java`.
5. `permissions: contents: read`. Секрети не використовуються.

## Перевірки
- YAML парситься (`python3 -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml'))"`).
- Присутні всі три ОС.
- У кроках `run` немає `mvn`/`javac`.
- Немає `secrets.` та токенів.

## Приклад входу
`Скрипти: ci.sh, ci.bat; гілки: develop, master`

## Очікуваний результат
Три зелені jobs у вкладці Actions: `build-test (ubuntu-latest)`, `(windows-latest)`, `(macos-latest)`.

## Типова помилка
| Помилка | Дія |
|---|---|
| На Windows `ci.bat` не запускається в pwsh | Вкажи `shell: cmd`. |
| `ci.sh: Permission denied` у CI | `git update-index --chmod=+x ci.sh` і закоміть. |
| Workflow вже існує | Онови лише відмінні блоки, не створюй другий файл. |
