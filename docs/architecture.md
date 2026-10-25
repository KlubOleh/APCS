# Архітектура AI-агента build-engineer

## 1. Які проблеми вирішує агент
- Ручне й неповторюване створення каркаса проєкту, системи складання, тестів і CI.
- Розбіжності між локальним складанням і CI (усунено: CI лише викликає `ci.sh` / `ci.bat`).
- Відсутність автоматичної перевірки результату (усунено: команда `check`).

## 2. Відповідність файлів ролям (GitHub Copilot у VS Code)
| Роль | Файл |
|---|---|
| Agent manifest | `.github/agents/build-engineer.agent.md` |
| Skill: створення проєкту | `.github/skills/project-scaffold/SKILL.md` |
| Skill: складання і тестування | `.github/skills/build-and-test/SKILL.md` |
| Skill: GitHub Actions | `.github/skills/github-actions/SKILL.md` |
| Command `git-init` | `.github/prompts/git-init.prompt.md` |
| Command `create-project` | `.github/prompts/create-project.prompt.md` |
| Command `create-build` | `.github/prompts/create-build.prompt.md` |
| Command `create-actions` | `.github/prompts/create-actions.prompt.md` |
| Command `check` | `.github/prompts/check.prompt.md` |
| Orchestrator `init-project` | `.github/prompts/init-project.prompt.md` |
| CI workflow | `.github/workflows/ci.yml` |

## 3. Взаємодія компонентів
```
          ┌─────────── manifest (правила, заборони, критерії) ───────────┐
          │                                                              │
/init-project ──► /git-init ─► /create-project ─► /create-build ─► /create-actions ─► /check
              │              │                 │                 │              │
              ▼              ▼                 ▼                 ▼              ▼
         .gitignore     project-scaffold   build-and-test   github-actions  scripts/check.sh
                         (src, README)   (Maven, тест, ci.*)  (ci.yml)
```

## 4. Дані між етапами
| Етап | Отримує | Передає |
|---|---|---|
| git-init | порожній/наявний репозиторій | `.gitignore`, стан Git |
| create-project | `.gitignore` | `src/main/java/*`, `README.md` |
| create-build | `src/main/java/*` | `pom.xml`, `src/test/java/*`, `ci.sh`, `ci.bat`, `dist/hello.jar` |
| create-actions | `ci.sh`, `ci.bat` | `.github/workflows/ci.yml` |
| check | усе вище | звіт `[OK]/[FAIL]`, код виходу |

## 5. Обробка помилок оркестратором
1. Кожен крок має власну перевірку. Невдача означає негайну зупинку (`init-project` не переходить далі).
2. Повідомлення про помилку містить назву команди та причину.
3. Підсумковий звіт `INIT REPORT` показує статус кожного кроку (`OK / SKIPPED / FAIL`).
4. Успіх можливий лише коли `scripts/check.sh --full` повертає код 0.
5. Небезпечні дії (видалення, force push, коміт, push) заборонені в manifest.

## 6. Ідемпотентність
Перед створенням файл перевіряється на існування. Коректні файли не змінюються, `.gitignore` доповнюється лише відсутніми рядками, залежності й плагіни в `pom.xml` не дублюються.

## 7. Обмеження агента
- Залежить від доступу до github.com (завантаження залежностей Maven і плагінів з Maven Central).
- Не комітить і не публікує зміни самостійно.
- Якість виконання залежить від моделі Copilot, тому результат завжди перевіряє `check`.

## 8. Примітка про назву оркестратора
Методичка називає оркестратор `init`. У VS Code `/init` є вбудованою командою Copilot (створює `.github/copilot-instructions.md`), тому
prompt-файл названо `init-project`. Функція та порядок викликів не змінені.
