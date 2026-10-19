# Архітектура AI-агента

## Задача
Автоматично створити, зібрати, протестувати та налаштувати CI для Java Hello World без ручного написання коду.

## Відповідність файлів ролям (GitHub Copilot / VS Code)
| Файл | Роль |
|---|---|
| `.github/agents/build-engineer.agent.md` | Agent manifest |
| `.github/skills/project-scaffold/SKILL.md` | Skill: каркас проєкту |
| `.github/skills/build-and-test/SKILL.md` | Skill: Maven + JUnit |
| `.github/skills/github-actions/SKILL.md` | Skill: CI |
| `.github/prompts/*.prompt.md` | Commands (`/git-init` … `/init`) |
| `.github/prompts/init.prompt.md` | Orchestrator |

Адаптація під Maven: замість `CMakeLists.txt` — `pom.xml`; тести у стандартному `src/test/java`
(замість `tests/`); вихідний каталог Maven змінено на `build/` (`<directory>build</directory>`).

## Взаємодія
```
init ─► git-init ─► create-project ─► create-build ─► create-actions ─► check
              │            │                 │                 │
              ▼            ▼                 ▼                 ▼
         .gitignore   project-scaffold  build-and-test   github-actions
```

## Дані між етапами
`git-init` → `.gitignore`, стан Git → `create-project` → `App.java`, README →
`create-build` → `pom.xml`, `Calculator`, тест, `ci.sh/ci.bat`, `build/hello.jar` →
`create-actions` → `ci.yml` → `check` → звіт PASS/FAIL.

## Обробка помилок
Оркестратор перевіряє «Перевірку» після кожного кроку; при помилці зупиняється, показує команду,
код виходу, фрагмент виводу й пропонує виправлення. Успіх без `check` не оголошується.

## Ідемпотентність
Кожна команда спершу перевіряє наявність файлів, оновлює їх, додає лише відсутні рядки, нічого не видаляє.

## Безпека
Заборонені: видалення файлів, force-push, зміна захисту гілок, робота з секретами.
