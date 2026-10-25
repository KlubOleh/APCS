---
name: project-scaffold
description: Створює мінімальний Hello World проєкт (структура каталогів, вихідний код, README, .gitignore). Використовуй, коли потрібно створити початковий каркас проєкту.
---

# project-scaffold

## Призначення
Створити каркас Java проєкту Hello World: каталоги Maven, клас `Main` із методом `main`,
допоміжний клас `MathUtils` з методом `add`, `README.md` і початковий `.gitignore`.

## Коли застосовувати
Після `git-init`, коли в репозиторії ще немає `Main.java`, або коли потрібно відновити відсутні файли каркаса.

## Вхідні дані
| Параметр | Значення за замовчуванням |
|---|---|
| Мова | `Java 17` |
| Назва проєкту | `HelloWorld` |
| Пакет | `com.example.hello` |
| Назва артефакту | `hello` (`hello.jar`) |

## Вихідні дані
- `src/main/java/com/example/hello/MathUtils.java`: метод `static int add(int a, int b)`.
- `src/main/java/com/example/hello/Main.java`: друкує `Hello, World!` і `2 + 3 = 5`.
- `README.md`, `.gitignore`, `.gitattributes`, каталоги `src/test/java/`, `docs/`, `scripts/`.

## Кроки
1. Створи відсутні каталоги.
2. Створи вихідні файли лише якщо їх немає (ідемпотентність).
3. У `.gitignore` додай тільки відсутні рядки: `target/`, `build/`, `dist/`, `.idea/`, `.vscode/`, `*.log`, `.env`.
4. Створи `README.md` із ПІП, групою, варіантом і способом запуску.

## Перевірки
- Файл `src/main/java/com/example/hello/Main.java` існує.
- `Main.java` містить рядок `Hello, World!`.
- У `.gitignore` є `target/`.
- Команда запуску описана в `README.md`.

## Приклад входу
`Мова: Java 17, назва: HelloWorld`

## Очікуваний результат
Дерево: `src/main/java/com/example/hello/{Main,MathUtils}.java`, `src/test/java/`, `docs/`, `README.md`, `.gitignore`.

## Типова помилка
| Помилка | Дія |
|---|---|
| `Main.java` вже існує з іншим вмістом | Не перезаписуй. Покажи різницю й запитай користувача. |
| `.gitignore` не містить `target/` | Додай один рядок, не дублюй існуючі. |
