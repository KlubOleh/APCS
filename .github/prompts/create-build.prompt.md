---
mode: agent
agent: build-engineer
description: Створює Maven-конфігурацію, юніт-тест BasicAddition і скрипти ci.sh/ci.bat через skill build-and-test.
---
# create-build
**Передумови:** виконано `create-project`; встановлено JDK 17+ та Maven (`java -version`, `mvn -version`).

**Дії:** застосуй skill `build-and-test`; потім виконай `mvn -B -ntp clean verify`.

**Очікувані файли:** `pom.xml`, `Calculator.java`, `CalculatorTest.java`, `ci.sh`, `ci.bat`, `build/hello.jar`.
**Перевірка:** `BUILD SUCCESS`, тест `BasicAddition` пройдено.
**Помилка:** покажи фрагмент виводу Maven, виправ код/конфігурацію і повтори; не змінюй тест, щоб він «пройшов».
