# Інструкція

## Запуск агента
1. VS Code + GitHub Copilot (під акаунтом зі студентським планом).
2. Copilot Chat → **Agent** mode → `/init`.
3. Перегляньте всі створені файли й результат `check`.

## Передумови
JDK 17+, Maven 3.9+, Git.

## Локальна перевірка
Linux/macOS: `bash ci.sh`
Windows: `ci.bat`

Вручну:
```
mvn -B clean verify
java -jar build/hello.jar     # Hello, World!
```
Тест `BasicAddition`: `mvn -B test -Dtest=CalculatorTest`.

## CI
Workflow `.github/workflows/ci.yml` запускається на push/pull_request до `develop`/`master`.
Виконавчий файл `hello.jar` зберігається як artifact для кожної ОС.
