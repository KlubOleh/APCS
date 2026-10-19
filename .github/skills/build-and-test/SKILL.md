---
name: build-and-test
description: Створює Maven pom.xml, клас з функцією додавання та JUnit 5 тест BasicAddition. Використовуй для налаштування складання й тестування.
---

# Коли застосовувати
Для команди `create-build`; після `project-scaffold`.

# Вхідні дані
Каркас проєкту з `src/main/java/com/example/hello/`.

# Дії
1. Створи/онови `pom.xml`: Java 17, JUnit Jupiter 5.10.x, `maven-compiler-plugin`,
   `maven-surefire-plugin`, `maven-jar-plugin` (Main-Class `com.example.hello.App`),
   `<build><directory>build</directory>`, `<finalName>hello</finalName>`.
2. Створи `Calculator.java` з `public static int add(int a, int b)`.
3. Створи `CalculatorTest.java` з тестом `BasicAddition` (`add(2, 3) == 5`).
4. Створи `ci.sh` і `ci.bat`: `mvn -B -ntp clean verify`, перевірка `build/hello.jar`, запуск jar.

# Очікуваний результат
`pom.xml`, `Calculator.java`, `CalculatorTest.java`, `ci.sh`, `ci.bat`; після збірки — `build/hello.jar`.

# Перевірки
- `mvn -B clean verify` → `BUILD SUCCESS`, `Tests run: 1, Failures: 0`.
- `build/hello.jar` існує; `java -jar build/hello.jar` виводить `Hello, World!`.
- `build/surefire-reports/TEST-*.xml` містить `BasicAddition`.

# Типова помилка
Тест падає (`expected 5 but was ...`) → виправ логіку `add`, а не тест. Maven/JDK відсутні →
зупинись і повідом, що потрібно встановити JDK 17+ та Maven.
