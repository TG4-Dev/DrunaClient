# Druna Flutter client

Мобильный клиент Druna для iOS и Android. Приложение переносит визуальную систему прототипа v18 (тёмная тема, цветовые поля событий, карточки и нижняя панель) на адаптивные Flutter-виджеты и работает с REST API из `context/FRONTEND_API.md`.

## Что реализовано

| Экран / сценарий | API | Состояния |
|---|---|---|
| Splash и восстановление сессии | secure storage, `POST /auth/renew-token` при 401 | restoring, offline, expired session |
| Регистрация и вход | `POST /auth/sign-up`, `POST /auth/sign-in` | validation, submitting, server error |
| Главная и список событий | `GET /api/v1/events/` | loading, refreshing, empty, error |
| Создание, редактирование, удаление события | `POST/PATCH/DELETE /api/v1/events/*` | validation, submitting, confirm delete |
| Профиль | `GET/PATCH /api/v1/users/me` | loading, edit, error, logout |
| Друзья, поиск и заявки | `/api/v1/friends/*` | loading, empty, search, incoming requests |
| Группы и участники | `/api/v1/groups/*` | loading, empty, create, details |
| Групповые события и общие окна | `/api/v1/groups/:id/events`, `/free-time` | loading, empty, CRUD, date selection |
| Уведомления | polling входящих заявок при открытии/refresh | loading, empty, error |

Опросы, гостевые приглашения, push delivery и подключение Apple/Google/Outlook Calendar показаны в дизайне, но отсутствуют в текущем backend-контракте. Приложение сообщает об этом пользователю и не имитирует успешное сохранение. Уведомления обновляются polling’ом, как предписывает API guide.

## Требования

- Flutter stable с Dart `>=3.8.1`
- Xcode для iOS и Android Studio/SDK для Android
- запущенный DrunaServer

## Запуск

```bash
flutter pub get
flutter run --dart-define-from-file=config/development.json
```

`development.json` настроен на iOS Simulator (`http://localhost:8000`). Для Android Emulator запусти так:

```bash
flutter run \
  --dart-define=APP_ENV=development \
  --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Для физического устройства укажи LAN IP машины с backend. Для production скопируй `config/production.example.json` в игнорируемый `config/production.json`, укажи реальный HTTPS URL и используй:

```bash
flutter build apk --release --dart-define-from-file=config/production.json
flutter build ipa --release --dart-define-from-file=config/production.json
```

HTTP разрешён только в Android debug manifest. Production должен использовать HTTPS. iOS разрешает локальную сеть для разработки, но release также следует собирать с HTTPS endpoint.

## Архитектура

```text
lib/
  app/             composition и состояние сессии
  core/            API client, config, secure storage, theme
  models/          доменные модели и DTO mapping
  repositories/    операции DrunaServer
  features/        auth, home, events, friends, groups, profile, notifications
  shared/ui/       кнопки, avatar, state panels, scaffold
```

`ApiClient` централизованно добавляет Bearer access token, разбирает `{data,error}`, выполняет один общий refresh для параллельных `401`, сохраняет ротированную пару и повторяет исходный запрос не более одного раза. Токены хранятся через `flutter_secure_storage` (Keychain на iOS, Keystore-backed storage на Android) и очищаются при ошибке refresh или выходе.

## Проверки

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Тесты покрывают success/error envelope, auth header, сохранение токенов, общий refresh для параллельных `401`, очистку невалидной сессии и welcome smoke flow.

Перед публикацией замените стандартные bundle/application identifiers и настройте release signing под аккаунты проекта.
