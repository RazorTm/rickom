# Rickom

Production-style Flutter приложение по Rick and Morty API с Clean Architecture, feature-first структурой и масштабируемым кодом.

## Overview

Rickom состоит из login flow и основной части приложения с тремя вкладками:
- Characters
- Carousel
- Settings

После успешного входа (`login: rick`, `password: morty`) пользователь попадает в основной shell.

## Features

### 1. Auth
- Отдельный flow логина.
- Валидация полей логина и пароля.
- Понятные ошибки при неуспешном входе.
- Навигация в main flow при успешной авторизации.

### 2. Characters
- Загрузка персонажей из Rick and Morty API.
- Пагинация списка.
- Обработка состояний: `initial`, `loading`, `success`, `pagination loading`, `error`.
- `SliverAppBar` с растягивающимся фоном (случайная картинка персонажа).
- Кнопка быстрого перехода к началу списка.
- Кликабельные карточки с dialog-деталями и изображением.

### 3. Carousel
- Отдельный экран с карточками персонажей в стиле carousel/pageview.
- Пагинация при достижении конца.
- Loader при догрузке.
- Кликабельные карточки.
- Bottom sheet с дополнительной информацией без изображения.

### 4. Settings
- Переключение темы: light/dark.
- Переключение языка: English/Русский.
- Глобальное применение темы и локали.
- Локальное сохранение настроек.
- Logout.

## Architecture

Проект построен по **Clean Architecture** и **feature-first**.

Каждая фича содержит слои:
- `data`
- `domain`
- `presentation`

Разделение ответственности:
- `data`: источники данных, DTO/модели, реализации репозиториев.
- `domain`: сущности, контракты репозиториев, use cases.
- `presentation`: BLoC, страницы, UI-виджеты.

Общий `core` слой:
- `constants`
- `di`
- `errors`
- `localization`
- `network`
- `router`
- `theme`
- `usecase`
- `utils`
- `widgets`

## Tech Stack

- Flutter (Material 3)
- `flutter_bloc` / `bloc` — state management
- `dio` — network layer
- `get_it` — dependency injection
- `shared_preferences` — local storage для темы/языка
- `equatable` — immutable/value equality
- `cached_network_image` — image loading/cache
- `google_fonts` — typography
- `flutter_localizations` + ARB — i18n (EN/RU)

## Project Structure

```text
lib/
  core/
  features/
    auth/
    characters/
    home/
    settings/
  l10n/
  app.dart
  main.dart
```

## Getting Started

### Prerequisites
- Flutter SDK `3.41.4`
- Dart SDK `3.11.1`

### Install dependencies

```bash
flutter pub get
```

### Run app

```bash
flutter run
```

### Static analysis

```bash
flutter analyze
```

## API

Используется публичный API:
- [Rick and Morty API](https://rickandmortyapi.com/)

## Localization

Поддерживаемые языки:
- English (`en`)
- Русский (`ru`)

Локализация настроена через ARB-файлы в `lib/l10n`.

## Notes

- После перезапуска приложение открывается с login flow.
- Тема и язык сохраняются локально.
