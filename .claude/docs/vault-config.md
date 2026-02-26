# Параметры vault

## Основные

| Параметр | Значение |
|----------|----------|
| vault_name | naumen_product_manager |
| vault_path | C:\Users\const\OneDrive\Рабочий стол\Assistant\my-vault |
| vault_tool | builtin (Grep/Glob/Read) |

## Директории

| Ключ | Путь | Описание |
|------|------|----------|
| people_dir | 10_PEOPLE | Профили людей |
| projects_dir | 30_PROJECTS/active | Активные проекты |
| committees_dir | 20_MEETINGS/committees | Комитеты |
| meetings_dir | 20_MEETINGS | Все встречи |
| templates_dir | 90_TEMPLATES | Шаблоны |
| decisions_dir | 40_DECISIONS | Решения |
| domain_dir | 60_DOMAIN/product | Доменные документы |

## Паттерны путей

| Тип документа | Паттерн |
|---------------|---------|
| Профиль человека | `10_PEOPLE/{id}/{id}.md` |
| 1-1 встреча | `10_PEOPLE/{id}/1-1/{date}.md` |
| Проект | `30_PROJECTS/active/{id}/{id}.md` |
| Решение | `40_DECISIONS/records/DEC-{NNNN}.md` |
| Комитет | `20_MEETINGS/committees/{id}/{date}.md` |

## ID людей

Схема: `{первая_буква_имени}{фамилия}` транслит → `amuratov`, `osmith`

## Ссылки Obsidian

- На людей: `[[10_PEOPLE/{id}/{id}|Имя Фамилия]]`
- На проекты: `[[30_PROJECTS/active/{id}/{id}|Название]]`
