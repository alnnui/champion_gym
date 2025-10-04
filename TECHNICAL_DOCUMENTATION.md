# Champion Fitness Gym App - Техническая документация для интеграции с CRM

## 📋 Обзор приложения

**Champion Fitness Gym App** - мобильное приложение для фитнес-клуба с полным функционалом управления членством, тренировками, статистикой и взаимодействием с клиентами.

---

## 🏗️ Архитектура приложения

### Технологический стек:
- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider
- **UI**: Material Design 3
- **Responsive**: flutter_screenutil
- **Icons**: SVG assets
- **Fonts**: Custom (Gilroy, Benzin)

### Структура проекта:
```
lib/
├── main.dart                    # Точка входа
├── modules/
│   ├── layout.dart             # Основной layout с AppBar и BottomNav
│   ├── layout/footbar.dart     # Нижняя навигация
│   ├── theme/colors.dart       # Цветовая схема
│   ├── components/
│   │   └── animated_tap.dart   # Анимированные кнопки
│   └── pages/                  # Все страницы приложения
```

---

## 📱 Основные страницы и функционал

### 1. 🏠 Главная страница (HomePage)

**Файл**: `lib/modules/pages/home.dart`

#### Функционал:
- **Приветствие пользователя** с персонализацией
- **Полоса прогресса** с анимацией (текущий вес: 70кг)
- **Карточка абонемента** с модальным окном деталей
- **Карточка посещений** (переход к ИИ ассистенту)
- **Карточка "Горячее"** (переход к акциям)
- **Секция клубов** с каталогом
- **Секция тренеров** с каталогом

#### Необходимые API методы:
```http
GET /api/user/profile
GET /api/user/membership
GET /api/user/progress
GET /api/clubs/list
GET /api/trainers/list
GET /api/promotions/featured
```

#### Данные для отображения:
```json
{
  "user": {
    "name": "string",
    "greeting": "string"
  },
  "membership": {
    "club": "string",
    "expires": "date",
    "type": "string",
    "status": "active|inactive"
  },
  "progress": {
    "current_weight": "number",
    "target_weight": "number",
    "progress_percentage": "number"
  }
}
```

---

### 2. 👤 Профиль пользователя (ProfilePage)

**Файл**: `lib/modules/pages/profile.dart`

#### Функционал:
- **Информация о пользователе** (имя, фото, статус)
- **Навигация к настройкам**:
  - Уведомления
  - Безопасность
- **Меню действий**:
  - Редактирование профиля
  - Выход из системы

#### Необходимые API методы:
```http
GET /api/user/profile
PUT /api/user/profile
POST /api/auth/logout
GET /api/user/avatar
POST /api/user/avatar
```

#### Данные профиля:
```json
{
  "user": {
    "id": "string",
    "name": "string",
    "email": "string",
    "phone": "string",
    "avatar_url": "string",
    "membership_status": "string",
    "join_date": "date"
  }
}
```

---

### 3. 📊 Статистика (StatsPage)

**Файл**: `lib/modules/pages/stats.dart`

#### Функционал:
- **Реферальный XP** - система лояльности
- **Посещаемость** - количество визитов
- **Средняя продолжительность** тренировок
- **Лучшее время посещения** - аналитика

#### Необходимые API методы:
```http
GET /api/user/stats/attendance
GET /api/user/stats/duration
GET /api/user/stats/peak-hours
GET /api/user/referral/xp
GET /api/user/stats/period?period=week|month|year
```

#### Данные статистики:
```json
{
  "attendance": {
    "visits_count": "number",
    "period": "week|month|year"
  },
  "duration": {
    "average_minutes": "number",
    "total_hours": "number"
  },
  "peak_hours": {
    "best_time": "string",
    "frequency": "number"
  },
  "referral": {
    "xp_points": "number",
    "level": "string"
  }
}
```

---

### 4. 💪 Тренировки и занятия (WorkoutsPage)

**Файл**: `lib/modules/pages/workouts.dart`

#### Функционал:
- **Табы**: Занятия / Мероприятия
- **Список групповых занятий**:
  - Йога, Пилатес, HIIT, Стретчинг
  - Информация о тренере, времени, месте
  - Количество свободных мест
  - Запись на занятие
- **Список мероприятий**:
  - Специальные события
  - Мастер-классы
  - Регистрация на мероприятия

#### Необходимые API методы:
```http
GET /api/classes/list
GET /api/classes/categories
POST /api/classes/book
DELETE /api/classes/cancel
GET /api/events/list
POST /api/events/register
GET /api/trainers/schedule
```

#### Данные занятий:
```json
{
  "classes": [
    {
      "id": "string",
      "title": "string",
      "category": "string",
      "trainer": "string",
      "datetime": "datetime",
      "duration_minutes": "number",
      "location": "string",
      "max_participants": "number",
      "current_participants": "number",
      "is_full": "boolean",
      "price": "number"
    }
  ],
  "events": [
    {
      "id": "string",
      "title": "string",
      "description": "string",
      "organizer": "string",
      "datetime": "datetime",
      "duration_minutes": "number",
      "location": "string",
      "max_participants": "number",
      "current_participants": "number",
      "is_special": "boolean",
      "price": "number"
    }
  ]
}
```

---

### 5. 🤖 ИИ Ассистент (AIAssistantPage)

**Файл**: `lib/modules/pages/ai_assistant.dart`

#### Функционал:
- **Чат-интерфейс** с ИИ помощником
- **Советы по питанию** и тренировкам
- **Персональные рекомендации**
- **История сообщений**

#### Необходимые API методы:
```http
POST /api/ai/chat
GET /api/ai/history
POST /api/ai/nutrition-advice
POST /api/ai/workout-advice
GET /api/ai/recommendations
```

#### Данные чата:
```json
{
  "messages": [
    {
      "id": "string",
      "type": "user|assistant",
      "content": "string",
      "timestamp": "datetime"
    }
  ],
  "recommendations": {
    "nutrition": "string",
    "workout": "string",
    "general": "string"
  }
}
```

---

### 6. 🏢 Каталог клубов (ClubsCatalogPage)

**Файл**: `lib/modules/pages/clubs_catalog.dart`

#### Функционал:
- **Список всех клубов** сети
- **Информация о клубе**:
  - Адрес, телефон, часы работы
  - Услуги и оборудование
  - Фотографии
- **Фильтрация** по районам/услугам

#### Необходимые API методы:
```http
GET /api/clubs/list
GET /api/clubs/{id}
GET /api/clubs/search?query=string
GET /api/clubs/filter?district=string&services=array
```

#### Данные клубов:
```json
{
  "clubs": [
    {
      "id": "string",
      "name": "string",
      "address": "string",
      "phone": "string",
      "email": "string",
      "working_hours": "object",
      "services": "array",
      "equipment": "array",
      "photos": "array",
      "rating": "number",
      "distance": "number"
    }
  ]
}
```

---

### 7. 👨‍💼 Каталог тренеров (TrainersCatalogPage)

**Файл**: `lib/modules/pages/trainers_catalog.dart`

#### Функционал:
- **Список тренеров** с профилями
- **Информация о тренере**:
  - Специализация, опыт
  - Рейтинг и отзывы
  - Расписание
- **Запись к тренеру**

#### Необходимые API методы:
```http
GET /api/trainers/list
GET /api/trainers/{id}
GET /api/trainers/specializations
POST /api/trainers/book
GET /api/trainers/schedule/{id}
```

#### Данные тренеров:
```json
{
  "trainers": [
    {
      "id": "string",
      "name": "string",
      "specialization": "array",
      "experience_years": "number",
      "rating": "number",
      "reviews_count": "number",
      "photo_url": "string",
      "bio": "string",
      "certifications": "array",
      "schedule": "object"
    }
  ]
}
```

---

### 8. 🔔 Настройки уведомлений (NotificationsSettingsPage)

**Файл**: `lib/modules/pages/notifications_settings.dart`

#### Функционал:
- **Управление уведомлениями**:
  - Push-уведомления
  - Email-уведомления
  - SMS-уведомления
- **Настройки времени** уведомлений
- **История уведомлений**

#### Необходимые API методы:
```http
GET /api/user/notifications/settings
PUT /api/user/notifications/settings
GET /api/user/notifications/history
POST /api/user/notifications/test
```

#### Настройки уведомлений:
```json
{
  "settings": {
    "push_enabled": "boolean",
    "email_enabled": "boolean",
    "sms_enabled": "boolean",
    "reminder_time": "string",
    "workout_reminders": "boolean",
    "promotion_notifications": "boolean"
  }
}
```

---

### 9. 🔒 Настройки безопасности (SecuritySettingsPage)

**Файл**: `lib/modules/pages/security_settings.dart`

#### Функционал:
- **Смена пароля**
- **Двухфакторная аутентификация**
- **Управление устройствами**
- **История входов**

#### Необходимые API методы:
```http
PUT /api/user/password
POST /api/user/2fa/enable
POST /api/user/2fa/disable
GET /api/user/devices
DELETE /api/user/devices/{id}
GET /api/user/login-history
```

---

### 10. 🎯 Акции и предложения (PromotionsPage)

**Файл**: `lib/modules/pages/promotions_page.dart`

#### Функционал:
- **Главная акция** с изображением
- **Специальное предложение** (годовой абонемент)
- **Список других акций**
- **Покупка абонементов**

#### Необходимые API методы:
```http
GET /api/promotions/list
GET /api/promotions/featured
POST /api/promotions/purchase
GET /api/memberships/plans
POST /api/memberships/purchase
```

#### Данные акций:
```json
{
  "promotions": [
    {
      "id": "string",
      "title": "string",
      "description": "string",
      "image_url": "string",
      "discount_percent": "number",
      "valid_until": "date",
      "is_featured": "boolean"
    }
  ],
  "membership_plans": [
    {
      "id": "string",
      "name": "string",
      "price": "number",
      "duration_months": "number",
      "features": "array",
      "is_popular": "boolean"
    }
  ]
}
```

---

## 🔧 Дополнительные компоненты

### 1. 🎨 Система тем (Theme System)

**Файлы**: `lib/modules/theme/colors.dart`

#### Функционал:
- **Светлая и темная тема**
- **Переключатель тем** в AppBar
- **Адаптивные цвета** для всех компонентов

#### Необходимые API методы:
```http
GET /api/user/preferences/theme
PUT /api/user/preferences/theme
```

### 2. 🎭 Анимированные компоненты

**Файл**: `lib/modules/components/animated_tap.dart`

#### Функционал:
- **Анимация нажатия** для всех интерактивных элементов
- **Визуальная обратная связь** для пользователя

### 3. 📱 Нижняя навигация (Footbar)

**Файл**: `lib/modules/layout/footbar.dart`

#### Функционал:
- **5 основных разделов**:
  - Главная, Статистика, Тренировки, Профиль
  - Центральная кнопка со штрихкодом
- **Штрихкод для входа** в клуб
- **Анимированные переходы**

#### Необходимые API методы:
```http
GET /api/user/barcode
POST /api/checkin/scan
```

---

## 🔐 Аутентификация и авторизация

### Необходимые API методы:
```http
POST /api/auth/login
POST /api/auth/register
POST /api/auth/refresh
POST /api/auth/logout
POST /api/auth/forgot-password
POST /api/auth/reset-password
```

### Токены и сессии:
```json
{
  "auth": {
    "access_token": "string",
    "refresh_token": "string",
    "expires_in": "number",
    "token_type": "Bearer"
  }
}
```

---

## 📊 Аналитика и метрики

### Необходимые API методы:
```http
POST /api/analytics/event
GET /api/analytics/user-activity
GET /api/analytics/usage-stats
```

### События для отслеживания:
- Открытие страниц
- Нажатие кнопок
- Запись на занятия
- Покупка абонементов
- Использование ИИ ассистента

---

## 🚀 Развертывание и конфигурация

### Переменные окружения:
```env
API_BASE_URL=https://api.championfitness.com
API_VERSION=v1
GOOGLE_MAPS_API_KEY=your_key
FIREBASE_PROJECT_ID=your_project
```

### Конфигурация для разных сред:
- **Development**: `https://dev-api.championfitness.com`
- **Staging**: `https://staging-api.championfitness.com`
- **Production**: `https://api.championfitness.com`

---

## 📋 Чек-лист для интеграции с CRM

### ✅ Обязательные API endpoints:

1. **Пользователи**:
   - [ ] `GET /api/user/profile`
   - [ ] `PUT /api/user/profile`
   - [ ] `GET /api/user/membership`
   - [ ] `GET /api/user/stats/*`

2. **Аутентификация**:
   - [ ] `POST /api/auth/login`
   - [ ] `POST /api/auth/logout`
   - [ ] `POST /api/auth/refresh`

3. **Тренировки**:
   - [ ] `GET /api/classes/list`
   - [ ] `POST /api/classes/book`
   - [ ] `GET /api/events/list`

4. **Клубы и тренеры**:
   - [ ] `GET /api/clubs/list`
   - [ ] `GET /api/trainers/list`

5. **Акции**:
   - [ ] `GET /api/promotions/list`
   - [ ] `POST /api/promotions/purchase`

6. **Уведомления**:
   - [ ] `GET /api/user/notifications/settings`
   - [ ] `PUT /api/user/notifications/settings`

### ✅ Дополнительные требования:

1. **Безопасность**:
   - [ ] HTTPS для всех запросов
   - [ ] JWT токены с refresh механизмом
   - [ ] Валидация входных данных

2. **Производительность**:
   - [ ] Пагинация для списков
   - [ ] Кэширование данных
   - [ ] Оптимизация изображений

3. **Мониторинг**:
   - [ ] Логирование API запросов
   - [ ] Метрики использования
   - [ ] Обработка ошибок

---

## 📞 Контакты для интеграции

**Техническая поддержка**: dev@championfitness.com
**Документация API**: https://api.championfitness.com/docs
**Статус сервисов**: https://status.championfitness.com

---

*Документация обновлена: $(date)*
*Версия приложения: 1.0.0*
