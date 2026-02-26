---
type: person
id: "shadrinv"
name: "Всеволод Шадрин"
aliases: [shadrinv, Всеволод Шадрин]
role: ""
team: ""
reporting: functional
since: 2026-02-26
status: active
domain: general
tags:
  - person
---

# Всеволод Шадрин

**Должность:**
**Подчинение:** Функциональное
**Команда:**

---

## Зона ответственности

-

---

## Подчинённые

| Имя | Роль | Примечание |
|-----|------|------------|
| | | |

---

## Текущие цели

| Цель | Срок | Статус |
|------|------|--------|
| | | |

---

## Сильные стороны

-

---

## Зоны развития

-

---

## Заметки

> [26.02] Профиль создан на основе участий в ktalk записях
> [26.02] Участвует в синхронизации планов и спринт-планировании
> [25.02] Присутствует на AI Sprint планировании
> [25.02] Участвует в обсуждении приоритетов и задач

---

## Участие в проектах

```dataview
TABLE WITHOUT ID
  link(file.link, id) as "Проект",
  title as "Название",
  status as "Статус"
FROM "30_PROJECTS/active"
WHERE type = "project" AND contains(file.outlinks, this.file.link)
SORT status ASC
```

---

## История 1-1

```dataview
TABLE date as "Дата", status as "Статус"
FROM "10_PEOPLE"
WHERE contains(file.path, this.file.folder) AND type = "1-1"
SORT date DESC
LIMIT 10
```

---

## История изменений

| Дата | Изменения |
|------|-----------|
| 26.02.2026 | Создание профиля на основе ktalk записей |
