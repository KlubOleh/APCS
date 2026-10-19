---
name: git-init
description: "Перевіряє Git-репозиторій, створює/оновлює .gitignore, показує стан Git."
disable-model-invocation: true
---
# git-init
**Передумови:** встановлено Git; поточний каталог — корінь проєкту.

**Дії:**
1. Якщо немає `.git` — виконай `git init` і створи гілку `develop`; інакше нічого не ініціалізуй.
2. Створи або доповни `.gitignore` (лише відсутні рядки): `build/`, `target/`, `*.class`, `*.log`, `.idea/`, `.vscode/`, `*.iml`, `.env`.
3. Виконай `git status --short --branch` і покажи результат.

**Очікувані файли:** `.gitignore`.
**Перевірка:** `git rev-parse --is-inside-work-tree` = `true`; `.gitignore` містить `build/`.
**Помилка:** якщо Git не знайдено — зупинись із повідомленням «Встановіть Git». Не роби commit, reset чи force-операцій.
