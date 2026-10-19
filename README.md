# Lab 1 — AI-агент build-engineer (Java + Maven + JUnit)

- ПІП _<Клуб Олег Михайлович>_
- Група: _<КІ-407>_
- Варіант: 5 — Java, Maven, JUnit 5
- GitHub: _<посилання на профіль>_

## Опис
Агент `build-engineer` (GitHub Copilot, VS Code) генерує кросплатформний Hello World,
складання Maven, юніт-тест `BasicAddition` та CI для Windows/Linux/macOS.

## Запуск агента
1. Відкрийте репозиторій у VS Code з активним GitHub Copilot.
2. Copilot Chat → режим **Agent**.
3. Виконайте `/bootstrap` (оркестратор). Окремі кроки: `/git-init`, `/create-project`, `/create-build`, `/create-actions`, `/check`.

## Запуск проєкту
```
mvn -B clean verify
java -jar build/hello.jar
```
Детально: [docs/usage.md](docs/usage.md). Архітектура: [docs/architecture.md](docs/architecture.md).
Журнал AI: [docs/ai-log.md](docs/ai-log.md).
