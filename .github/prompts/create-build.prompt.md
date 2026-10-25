---
agent: build-engineer
description: Викликає skill build-and-test і створює Maven-конфігурацію (pom.xml), юніт-тест та скрипти ci.sh / ci.bat.
---

# /create-build

## Передумови
- Існує `Main.java` (результат `create-project`). Якщо немає, зупинись і порекомендуй `/create-project`.

## Дії
Прочитай і виконай `.github/skills/build-and-test/SKILL.md`.
Потім запусти `./ci.sh` (Linux/macOS) або `ci.bat` (Windows) і покажи результат.

## Очікувані файли
`pom.xml`, `src/test/java/com/example/hello/BasicAdditionTest.java`, `ci.sh`, `ci.bat`, `scripts/check.sh`, `dist/hello.jar`.

## Перевірка
- `mvn verify` проходить, у виводі `BasicAdditionTest`, `Tests run: 1, Failures: 0`.
- `java -jar dist/hello.jar` виводить `Hello, World!`.

## Повідомлення про помилку
`ПОМИЛКА create-build: <крок> завершився з кодом <N>. Наведи останні 20 рядків виводу.`

## Ідемпотентність
Не дублюй залежності й плагіни в `pom.xml`, тест `BasicAddition`. Існуючі коректні файли не перезаписуй.
