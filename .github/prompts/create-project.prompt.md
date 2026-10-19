---
mode: agent
agent: build-engineer
description: Створює початковий Java Hello World проєкт через skill project-scaffold.
---
# create-project
**Передумови:** виконано `git-init`.

**Дії:** застосуй skill `project-scaffold` з `language=java`, `projectName=hello`.

**Очікувані файли:** `src/main/java/com/example/hello/App.java`, `README.md`.
**Перевірка:** файли існують; `App.java` містить `main`.
**Помилка:** якщо файл існує з іншим вмістом — не перезаписуй, покажи відмінності й запитай користувача.
