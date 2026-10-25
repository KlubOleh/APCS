---
name: build-and-test
description: Створює Maven-конфігурацію (pom.xml), юніт-тест JUnit 5 BasicAddition та скрипти ci.sh / ci.bat для складання й тестування. Використовуй після project-scaffold.
---

# build-and-test

## Призначення
Налаштувати складання (Maven), юніт-тестування (JUnit 5 + surefire) і кросплатформні скрипти
`ci.sh` (Linux/macOS) та `ci.bat` (Windows), які збирають проєкт, запускають тести та кладуть
виконуваний `hello.jar` у `dist/`.

## Вхідні дані
- Наявні `Main.java`, `MathUtils.java` (результат `project-scaffold`).
- JDK 17+, Maven 3.8+.

## Вихідні дані
- `pom.xml`: `groupId com.example`, `artifactId hello`, `finalName hello`, `maven.compiler.release 17`, залежність `junit-jupiter` (scope test), плагіни `maven-surefire-plugin` (≥ 3.0, інакше JUnit 5 не запускається) і `maven-jar-plugin` з `mainClass com.example.hello.Main`.
- `src/test/java/com/example/hello/BasicAdditionTest.java`: тест з `@DisplayName("BasicAddition")`.
- `ci.sh`, `ci.bat`: `mvn -B -ntp clean verify` → копіювання `target/hello.jar` у `dist/` → запуск JAR через Java з `JAVA_HOME`, якщо змінну задано, інакше через `java` з `PATH`.
- `scripts/check.sh`.

## Кроки
1. Створи або онови `pom.xml` (не дублюй плагіни й залежності).
2. Створи `BasicAdditionTest.java`.
3. Створи `ci.sh` (LF, `set -euo pipefail`) і `ci.bat` (CRLF, `if errorlevel 1 exit /b 1`; `mvn` викликай через `call`).
4. Зроби `ci.sh` виконуваним: `chmod +x ci.sh` (у Git: `git update-index --chmod=+x ci.sh`).
5. Запусти локально `./ci.sh` (Linux/macOS) або `ci.bat` (Windows).

## Перевірки
- `target/hello.jar` і `dist/hello.jar` існують.
- Перевірка Java повідомляє версію 17 або новішу; для запуску використовується Java з `JAVA_HOME`, якщо його задано.
- У виводі Maven: `Running com.example.hello.BasicAdditionTest` та `Tests run: 1, Failures: 0, Errors: 0`.
- `java -jar dist/hello.jar` виводить `Hello, World!`.

## Приклад входу
`JDK 17, Maven 3.8+, доступ до Maven Central`

## Очікуваний результат
```
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
BUILD SUCCESS
Hello, World!
```

## Типова помилка
| Помилка | Дія |
|---|---|
| `Tests run: 0` (тести не запустились) | Перевір версію surefire (≥ 3.0) і назву класу (`*Test`). |
| Немає доступу до Maven Central | Повідом причину, не підміняй тест заглушкою. |
| `Permission denied: ./ci.sh` | `chmod +x ci.sh`. |
| `no main manifest attribute` | Перевір `mainClass` у `maven-jar-plugin`. |
| `UnsupportedClassVersionError` | Запущена Java старіша за версію, на яку зібрано класи (Java 17). Задай `JAVA_HOME` на JDK 17+ або виправ `PATH`, щоб `java` вказував на сумісну версію; CI-скрипти використовують Java з `JAVA_HOME`, якщо він заданий. |
