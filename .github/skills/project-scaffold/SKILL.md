---
name: project-scaffold
description: Створює мінімальний Java Hello World проєкт (src, README, .gitignore). Використовуй, коли потрібен початковий каркас проєкту.
---

# Коли застосовувати
Для створення початкової структури проєкту (команда `create-project`).

# Вхідні дані
- `language` — `java` (за замовчуванням).
- `projectName` — `hello` (за замовчуванням); groupId `com.example`, пакет `com.example.hello`.

Приклад входу: `language=java, projectName=hello`.

# Дії
1. Створи каталоги `src/main/java/com/example/hello/`, `src/test/java/com/example/hello/`, `docs/`.
2. Створи `App.java` з `main`, який друкує `Hello, World!`.
3. Створи `README.md` (ПІП, група, варіант 5, опис, запуск агента) — лише якщо його немає.
4. Створи/онови `.gitignore`: `build/`, `target/`, `*.class`, `*.log`, `.idea/`, `.vscode/`, `*.iml`, `.env`.
   Додавай лише відсутні рядки.

# Очікуваний результат
`src/main/java/com/example/hello/App.java`, `README.md`, `.gitignore`.

# Перевірки
- `App.java` існує і містить `public static void main`.
- `.gitignore` містить `build/`.
- Команда запуску задокументована: `java -jar build/hello.jar`.

# Типова помилка
`App.java` вже існує з іншим вмістом → не перезаписуй; покажи diff і запитай користувача.
