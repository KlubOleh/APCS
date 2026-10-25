---
agent: build-engineer
description: Оркестратор. Послідовно запускає git-init, create-project, create-build, create-actions, check і зупиняється при першій помилці.
---

# /init-project (orchestrator)

> Назва `init-project` (а не `init`), бо `/init` у VS Code Copilot є вбудованою командою, яка створює `copilot-instructions.md`.
> Запуск: `/init-project` у Copilot Chat (режим Agent) або `Ctrl+Shift+P` → `Chat: Run Prompt…` → `init-project`.

## Передумови
- Порожній або наявний репозиторій; встановлено Git, JDK 17+, Maven 3.8+, Python 3 (для перевірки YAML).
- Перевір версії: `git --version`, `java -version`, `mvn -version`, `python3 --version`. Якщо чогось немає, зупинись і вкажи, чого саме.

## Порядок виконання (суворий)
| № | Command | Файл інструкції | Що передається далі |
|---|---|---|---|
| 1 | git-init | `.github/prompts/git-init.prompt.md` | `.gitignore`, стан Git |
| 2 | create-project | `.github/prompts/create-project.prompt.md` | `src/main/java/*`, `README.md` |
| 3 | create-build | `.github/prompts/create-build.prompt.md` | `pom.xml`, тести, `ci.sh`, `ci.bat` |
| 4 | create-actions | `.github/prompts/create-actions.prompt.md` | `.github/workflows/ci.yml` |
| 5 | check | `.github/prompts/check.prompt.md` | підсумковий звіт |

## Правила
1. Виконуй кроки по черзі, читаючи відповідний файл інструкції.
2. Після кожного кроку виконай його перевірку. Якщо вона не пройшла: **зупинись**, виведи повідомлення про помилку з команди й не переходь далі.
3. Не вважай роботу успішною без кроку 5 (`check`) з кодом 0.
4. Не виконуй `git commit` і `git push` самостійно.
5. Повторний запуск: кроки, чий результат уже коректний, позначай `SKIPPED (вже існує)`. Нічого не видаляй і не дублюй.

## Підсумковий звіт (формат)
```
INIT REPORT
1 git-init        : OK | SKIPPED | FAIL
2 create-project  : OK | SKIPPED | FAIL
3 create-build    : OK | SKIPPED | FAIL
4 create-actions  : OK | SKIPPED | FAIL
5 check           : OK | FAIL
Створено файлів: N; змінено: M; пропущено: K
Наступний крок: переглянути git diff і закомітити вручну
```
