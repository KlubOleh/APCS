---
agent: build-engineer
description: Викликає skill project-scaffold і створює початковий Java Hello World проєкт.
---

# /create-project

## Передумови
- Виконано `git-init` (або `.gitignore` існує).

## Дії
Прочитай і виконай `.github/skills/project-scaffold/SKILL.md` з параметрами:
- мова: Java 17; назва: HelloWorld; пакет: `com.example.hello`; артефакт: `hello.jar`.

## Очікувані файли
`src/main/java/com/example/hello/Main.java`, `MathUtils.java`, `README.md`, `docs/`, `scripts/`.

## Перевірка
- `test -f src/main/java/com/example/hello/Main.java`
- `grep -q 'Hello, World!' src/main/java/com/example/hello/Main.java`

## Повідомлення про помилку
`ПОМИЛКА create-project: відсутній <файл>. Skill project-scaffold не завершено.`

## Ідемпотентність
Існуючі файли з коректним вмістом не змінюються. Якщо вміст відрізняється, покажи різницю й запитай користувача.
