# Лабораторна робота №1: AI-агент для автоматизації розробки та CI/CD

| | |
|---|---|
| **ПІП** | Клуб О. М. |
| **Група** | КІ-407 |
| **Варіант** | 11 (Java 17 / Maven / JUnit 5) |
| **Викладач** | Чапля О. Ю. |

Проєкт: мінімальний кросплатформний застосунок **Hello World** (`hello`) з юніт-тестом `BasicAddition`.
Увесь проєкт створюється AI-агентом **build-engineer** (GitHub Copilot, VS Code).

## Запуск агента
1. VS Code + розширення GitHub Copilot (обліковий запис зі студентським планом).
2. Відкрити корінь репозиторію, вибрати **Copilot Chat → Agent mode**.
3. Виконати в чаті: `/init-project` (оркестратор; `/init` зайнята вбудованою командою Copilot)

Окремі команди: `/git-init`, `/create-project`, `/create-build`, `/create-actions`, `/check`.

## Запуск зібраного проєкту
```bash
# Linux / macOS
./ci.sh
java -jar dist/hello.jar

# Windows (cmd)
ci.bat
java -jar dist\hello.jar
```
Очікуваний вивід:
```
Hello, World!
2 + 3 = 5
```

## Перевірка
```bash
bash scripts/check.sh --full
```

## Документація
- [docs/architecture.md](docs/architecture.md): архітектура агента
- [docs/usage.md](docs/usage.md): точні команди запуску
