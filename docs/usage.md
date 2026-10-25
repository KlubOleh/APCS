# Інструкція запуску

## Агент (VS Code + GitHub Copilot)
1. Відкрити репозиторій у VS Code, увійти в Copilot під підтвердженим студентським акаунтом.
2. Copilot Chat → режим **Agent**.
3. Ввести: `/init`
4. Переглянути створені файли (`git status`, `git diff`), відповідно до `INIT REPORT`.

Окремі команди: `/git-init`, `/create-project`, `/create-build`, `/create-actions`, `/check`.

## Локальна перевірка
```bash
bash scripts/check.sh --full
```
Код виходу `0` означає успіх.

## Складання і запуск без агента
Вимоги: JDK 17+, Maven 3.8+, доступ до Maven Central.

| ОС | Команди |
|---|---|
| Linux / macOS | `./ci.sh` потім `java -jar dist/hello.jar` |
| Windows (cmd) | `ci.bat` потім `java -jar dist\hello.jar` |

Тести окремо: `mvn -B test`

## Git-процес
```bash
git checkout -b develop            # лише агент та інструкції
git checkout -b feature/hello-cpp  # результат запуску /init
# pull request: feature/hello-cpp -> develop, назва lab1/finish
```
