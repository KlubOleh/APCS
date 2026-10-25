---
agent: build-engineer
description: Перевіряє Git-репозиторій, створює або оновлює .gitignore, показує стан Git.
---

# /git-init

## Передумови
- Git встановлено (`git --version`).
- Поточний каталог: корінь репозиторію.

## Дії
1. Якщо `.git/` немає, виконай `git init` і повідом про це. Якщо є, нічого не перетирай.
2. Створи `.gitignore`, якщо його немає. Якщо є, додай лише відсутні рядки: `target/`, `build/`, `dist/`, `.idea/`, `.vscode/`, `*.log`, `.env`.
3. Покажи `git status --short` і `git branch --show-current`.
4. Перевір, що `target/`, `build/`, `dist/` не відстежуються: `git ls-files target build dist` має бути порожнім.

## Очікувані файли
`.git/`, `.gitignore`, `.gitattributes`

## Перевірка
`grep -qx 'target/' .gitignore` повертає 0.

## Повідомлення про помилку
- Git не знайдено → `ПОМИЛКА git-init: Git не встановлено. Встановіть Git і повторіть.`
- `target/` або `dist/` відстежується → `ПОМИЛКА git-init: target/ або dist/ у Git. Виконайте 'git rm -r --cached target dist' вручну.` (не видаляй файли самостійно).

## Ідемпотентність
Повторний запуск не змінює вже наявні рядки та не дублює їх.
