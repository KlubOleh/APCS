---
mode: agent
agent: build-engineer
description: Лише перевіряє проєкт (нічого не змінює у вихідних файлах): структура, складання, тести, YAML.
---
# check
**Не змінюй файли проєкту.** Дозволено лише запуск перевірок (збірка пише тільки в `build/`).

**Перевір і виведи таблицю PASS/FAIL:**
1. Існують: agent manifest (з роллю, забороненими діями, критеріями), 3 skills (з входами/виходами/перевірками), 6 prompts.
2. Існують: `pom.xml`, `App.java`, `Calculator.java`, `CalculatorTest.java`, `ci.sh`, `ci.bat`, `README.md`.
3. `mvn -B -ntp clean verify` успішний; тест `BasicAddition` виконано.
4. `build/hello.jar` існує; `java -jar build/hello.jar` друкує `Hello, World!`.
5. `ci.yml`: валідний YAML, три ОС, `push`/`pull_request`, виклик `ci.sh`/`ci.bat`.
6. `git check-ignore build/` успішно; у відстежуваних файлах (`git ls-files`) немає `build/`, `target/`, `.env`, токенів.

**Підсумок:** `CHECK PASSED` або `CHECK FAILED` з переліком проблем. При будь-якому FAIL — код помилки, жодних автоматичних виправлень.
