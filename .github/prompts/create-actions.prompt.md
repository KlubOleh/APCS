---
agent: build-engineer
description: Викликає skill github-actions і створює CI workflow для Windows, Linux і macOS.
---

# /create-actions

## Передумови
- Існують `ci.sh` та `ci.bat`.

## Дії
Прочитай і виконай `.github/skills/github-actions/SKILL.md`.

## Очікувані файли
`.github/workflows/ci.yml`

## Перевірка
- `python3 -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml'))"` без помилок.
- У файлі є `ubuntu-latest`, `windows-latest`, `macos-latest`.
- У `run:` немає `mvn`, `javac`, `java`.

## Повідомлення про помилку
`ПОМИЛКА create-actions: <причина>. Workflow не створено/не оновлено.`

## Ідемпотентність
Якщо `ci.yml` існує й коректний, залиш без змін. Не створюй другий workflow.
