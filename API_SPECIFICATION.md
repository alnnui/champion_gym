# Champion Fitness Gym App - API Спецификация

## 🔗 Базовые настройки API

### Base URL
```
Production: https://api.championfitness.com/v1
Development: https://dev-api.championfitness.com/v1
```

### Аутентификация
```
Authorization: Bearer {access_token}
Content-Type: application/json
```

---

## 👤 Пользователи и профили

### 1. Получение профиля пользователя
```http
GET /api/user/profile
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "user_123",
    "name": "Иван Петров",
    "email": "ivan@example.com",
    "phone": "+7 777 123 45 67",
    "avatar_url": "https://cdn.championfitness.com/avatars/user_123.jpg",
    "membership_status": "active",
    "join_date": "2024-01-15T10:30:00Z",
    "preferred_club": "kazhymukan",
    "preferences": {
      "theme": "dark",
      "language": "ru",
      "notifications": {
        "push": true,
        "email": true,
        "sms": false
      }
    }
  }
}
```

### 2. Обновление профиля
```http
PUT /api/user/profile
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Иван Петров",
  "phone": "+7 777 123 45 67",
  "preferences": {
    "theme": "light",
    "notifications": {
      "push": true,
      "email": false
    }
  }
}
```

### 3. Загрузка аватара
```http
POST /api/user/avatar
Authorization: Bearer {token}
Content-Type: multipart/form-data

file: [image_file]
```

---

## 🎫 Абонементы и членство

### 1. Информация об абонементе
```http
GET /api/user/membership
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "membership_456",
    "type": "business",
    "club": "kazhymukan",
    "club_name": "Кажымукана",
    "start_date": "2024-01-15T00:00:00Z",
    "expires_date": "2025-01-15T00:00:00Z",
    "status": "active",
    "remaining_visits": 45,
    "unlimited": false,
    "features": [
      "gym_access",
      "group_classes",
      "locker_room",
      "parking"
    ],
    "price": {
      "monthly": 15000,
      "currency": "KZT"
    }
  }
}
```

### 2. История абонементов
```http
GET /api/user/membership/history
Authorization: Bearer {token}
```

### 3. Продление абонемента
```http
POST /api/user/membership/renew
Authorization: Bearer {token}
Content-Type: application/json

{
  "membership_type": "business",
  "duration_months": 12,
  "payment_method": "card"
}
```

---

## 📊 Статистика и аналитика

### 1. Статистика посещений
```http
GET /api/user/stats/attendance?period=month&year=2024&month=10
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "period": "month",
    "year": 2024,
    "month": 10,
    "visits_count": 18,
    "visits_by_day": [
      {"date": "2024-10-01", "visits": 1},
      {"date": "2024-10-02", "visits": 0},
      {"date": "2024-10-03", "visits": 1}
    ],
    "average_visits_per_week": 4.5,
    "total_hours": 36.5,
    "average_duration_minutes": 121
  }
}
```

### 2. Статистика продолжительности
```http
GET /api/user/stats/duration?period=month
Authorization: Bearer {token}
```

### 3. Лучшее время посещения
```http
GET /api/user/stats/peak-hours?period=month
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "best_time": "19:00",
    "frequency": 8,
    "hourly_distribution": [
      {"hour": "06:00", "visits": 2},
      {"hour": "07:00", "visits": 5},
      {"hour": "19:00", "visits": 8},
      {"hour": "20:00", "visits": 6}
    ]
  }
}
```

### 4. Реферальная система
```http
GET /api/user/referral/xp
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "current_xp": 1250,
    "level": "silver",
    "next_level_xp": 500,
    "referrals_count": 3,
    "total_earned_xp": 1250,
    "rewards": [
      {
        "id": "free_month",
        "name": "Бесплатный месяц",
        "xp_cost": 1000,
        "available": true
      }
    ]
  }
}
```

---

## 💪 Тренировки и занятия

### 1. Список групповых занятий
```http
GET /api/classes/list?club=kazhymukan&date=2024-10-15&category=yoga
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "classes": [
      {
        "id": "class_789",
        "title": "Утренняя йога",
        "category": "yoga",
        "trainer": {
          "id": "trainer_123",
          "name": "Анастасия",
          "photo_url": "https://cdn.championfitness.com/trainers/anastasia.jpg"
        },
        "datetime": "2024-10-15T09:00:00Z",
        "duration_minutes": 60,
        "location": "Зал 1",
        "max_participants": 20,
        "current_participants": 15,
        "spots_left": 5,
        "is_full": false,
        "price": 2000,
        "currency": "KZT",
        "difficulty": "beginner",
        "description": "Расслабляющая утренняя практика йоги"
      }
    ],
    "pagination": {
      "page": 1,
      "per_page": 20,
      "total": 45,
      "total_pages": 3
    }
  }
}
```

### 2. Запись на занятие
```http
POST /api/classes/book
Authorization: Bearer {token}
Content-Type: application/json

{
  "class_id": "class_789",
  "user_id": "user_123"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "booking_id": "booking_456",
    "class_id": "class_789",
    "user_id": "user_123",
    "status": "confirmed",
    "booking_time": "2024-10-14T15:30:00Z",
    "qr_code": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA..."
  }
}
```

### 3. Отмена записи
```http
DELETE /api/classes/cancel/{booking_id}
Authorization: Bearer {token}
```

### 4. Мои записи
```http
GET /api/user/bookings?status=upcoming
Authorization: Bearer {token}
```

---

## 🎪 Мероприятия

### 1. Список мероприятий
```http
GET /api/events/list?club=kazhymukan&date_from=2024-10-15&date_to=2024-10-31
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "events": [
      {
        "id": "event_101",
        "title": "Мастер-класс по кроссфиту",
        "description": "Интенсивный мастер-класс с профессиональными тренерами",
        "organizer": "Champion Fitness",
        "datetime": "2024-10-20T18:00:00Z",
        "duration_minutes": 120,
        "location": "Основной зал",
        "max_participants": 50,
        "current_participants": 32,
        "spots_left": 18,
        "is_full": false,
        "is_special": true,
        "price": 5000,
        "currency": "KZT",
        "image_url": "https://cdn.championfitness.com/events/crossfit_masterclass.jpg"
      }
    ]
  }
}
```

### 2. Регистрация на мероприятие
```http
POST /api/events/register
Authorization: Bearer {token}
Content-Type: application/json

{
  "event_id": "event_101",
  "user_id": "user_123"
}
```

---

## 🤖 ИИ Ассистент

### 1. Отправка сообщения
```http
POST /api/ai/chat
Authorization: Bearer {token}
Content-Type: application/json

{
  "message": "Как правильно питаться после тренировки?",
  "context": {
    "user_goals": ["weight_loss", "muscle_gain"],
    "fitness_level": "intermediate",
    "dietary_restrictions": ["lactose_free"]
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "message_id": "msg_789",
    "response": "После тренировки важно восполнить запасы гликогена и белка. Рекомендую съесть банан с протеиновым коктейлем в течение 30 минут после тренировки...",
    "timestamp": "2024-10-14T16:45:00Z",
    "suggestions": [
      "Показать рецепты протеиновых коктейлей",
      "Составить план питания на неделю"
    ]
  }
}
```

### 2. История чата
```http
GET /api/ai/history?page=1&limit=20
Authorization: Bearer {token}
```

### 3. Персональные рекомендации
```http
GET /api/ai/recommendations
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "nutrition": {
      "daily_calories": 2200,
      "protein_grams": 165,
      "water_liters": 2.5,
      "meals": [
        {
          "time": "08:00",
          "meal": "breakfast",
          "suggestion": "Овсянка с ягодами и орехами"
        }
      ]
    },
    "workout": {
      "recommended_classes": ["yoga", "strength_training"],
      "frequency": "4-5 раз в неделю",
      "duration": "45-60 минут"
    }
  }
}
```

---

## 🏢 Клубы

### 1. Список клубов
```http
GET /api/clubs/list?city=almaty&services=gym,pool
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "clubs": [
      {
        "id": "club_001",
        "name": "Кажымукана",
        "address": "ул. Кажымукана, 123",
        "city": "Алматы",
        "phone": "+7 727 123 45 67",
        "email": "kazhymukan@championfitness.com",
        "working_hours": {
          "monday": "06:00-23:00",
          "tuesday": "06:00-23:00",
          "sunday": "08:00-22:00"
        },
        "services": ["gym", "pool", "sauna", "group_classes"],
        "equipment": ["treadmills", "weights", "yoga_mats"],
        "photos": [
          "https://cdn.championfitness.com/clubs/kazhymukan/1.jpg"
        ],
        "rating": 4.8,
        "reviews_count": 156,
        "distance_km": 2.3,
        "coordinates": {
          "lat": 43.2220,
          "lng": 76.8512
        }
      }
    ]
  }
}
```

### 2. Детальная информация о клубе
```http
GET /api/clubs/{club_id}
Authorization: Bearer {token}
```

---

## 👨‍💼 Тренеры

### 1. Список тренеров
```http
GET /api/trainers/list?club=kazhymukan&specialization=yoga
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "trainers": [
      {
        "id": "trainer_123",
        "name": "Анастасия",
        "last_name": "Петрова",
        "specialization": ["yoga", "pilates", "stretching"],
        "experience_years": 5,
        "rating": 4.9,
        "reviews_count": 89,
        "photo_url": "https://cdn.championfitness.com/trainers/anastasia.jpg",
        "bio": "Сертифицированный инструктор йоги с 5-летним опытом...",
        "certifications": [
          "RYT 200 Yoga Alliance",
          "Pilates Mat Certification"
        ],
        "languages": ["ru", "en"],
        "schedule": {
          "monday": ["09:00-12:00", "18:00-21:00"],
          "tuesday": ["09:00-12:00", "18:00-21:00"]
        },
        "price_per_session": 5000,
        "currency": "KZT"
      }
    ]
  }
}
```

### 2. Запись к тренеру
```http
POST /api/trainers/book
Authorization: Bearer {token}
Content-Type: application/json

{
  "trainer_id": "trainer_123",
  "datetime": "2024-10-20T10:00:00Z",
  "duration_minutes": 60,
  "type": "personal_training"
}
```

---

## 🎯 Акции и предложения

### 1. Список акций
```http
GET /api/promotions/list?active=true&featured=true
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "promotions": [
      {
        "id": "promo_001",
        "title": "Приведи друга - получи скидку 25%",
        "description": "Приведите друга в наш клуб и получите 25% скидку на ваш абонемент, а ваш друг получит абонемент в подарок!",
        "image_url": "https://cdn.championfitness.com/promotions/friend_discount.jpg",
        "discount_percent": 25,
        "valid_from": "2024-10-01T00:00:00Z",
        "valid_until": "2024-12-31T23:59:59Z",
        "is_featured": true,
        "terms": "Действует для новых клиентов",
        "code": "FRIEND25"
      }
    ]
  }
}
```

### 2. Планы абонементов
```http
GET /api/memberships/plans?club=kazhymukan
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "plans": [
      {
        "id": "plan_business",
        "name": "Бизнес",
        "description": "Полный доступ ко всем услугам клуба",
        "price_monthly": 15000,
        "price_yearly": 150000,
        "currency": "KZT",
        "duration_months": 12,
        "features": [
          "Неограниченный доступ в зал",
          "Групповые занятия",
          "Сауна и бассейн",
          "Парковка",
          "Персональный шкафчик"
        ],
        "is_popular": true,
        "discount_percent": 17
      }
    ]
  }
}
```

### 3. Покупка абонемента
```http
POST /api/memberships/purchase
Authorization: Bearer {token}
Content-Type: application/json

{
  "plan_id": "plan_business",
  "payment_method": "card",
  "duration_months": 12,
  "promo_code": "FRIEND25"
}
```

---

## 🔔 Уведомления

### 1. Настройки уведомлений
```http
GET /api/user/notifications/settings
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "push_enabled": true,
    "email_enabled": true,
    "sms_enabled": false,
    "reminder_time": "18:00",
    "workout_reminders": true,
    "promotion_notifications": true,
    "class_reminders": true,
    "membership_expiry_reminders": true
  }
}
```

### 2. Обновление настроек
```http
PUT /api/user/notifications/settings
Authorization: Bearer {token}
Content-Type: application/json

{
  "push_enabled": true,
  "email_enabled": false,
  "reminder_time": "19:00"
}
```

### 3. История уведомлений
```http
GET /api/user/notifications/history?page=1&limit=20
Authorization: Bearer {token}
```

---

## 🔒 Безопасность

### 1. Смена пароля
```http
PUT /api/user/password
Authorization: Bearer {token}
Content-Type: application/json

{
  "current_password": "old_password",
  "new_password": "new_secure_password"
}
```

### 2. Включение 2FA
```http
POST /api/user/2fa/enable
Authorization: Bearer {token}
```

### 3. Управление устройствами
```http
GET /api/user/devices
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "devices": [
      {
        "id": "device_123",
        "name": "iPhone 15 Pro",
        "os": "iOS 17.0",
        "last_active": "2024-10-14T15:30:00Z",
        "is_current": true
      }
    ]
  }
}
```

---

## 📱 Штрихкод и вход в клуб

### 1. Получение штрихкода
```http
GET /api/user/barcode
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "barcode": "123456789012",
    "qr_code": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
    "expires_at": "2025-01-15T00:00:00Z"
  }
}
```

### 2. Сканирование при входе
```http
POST /api/checkin/scan
Authorization: Bearer {token}
Content-Type: application/json

{
  "barcode": "123456789012",
  "club_id": "club_001",
  "scanner_id": "scanner_001"
}
```

---

## 📊 Аналитика и события

### 1. Отправка события
```http
POST /api/analytics/event
Authorization: Bearer {token}
Content-Type: application/json

{
  "event_name": "page_view",
  "event_data": {
    "page": "home",
    "timestamp": "2024-10-14T16:45:00Z",
    "user_id": "user_123"
  }
}
```

### 2. Статистика использования
```http
GET /api/analytics/usage-stats?period=month
Authorization: Bearer {token}
```

---

## ❌ Обработка ошибок

### Стандартный формат ошибок:
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Неверные данные запроса",
    "details": {
      "field": "email",
      "reason": "Неверный формат email"
    }
  }
}
```

### Коды ошибок:
- `400` - Неверный запрос
- `401` - Не авторизован
- `403` - Доступ запрещен
- `404` - Не найдено
- `409` - Конфликт (например, занятие уже забронировано)
- `422` - Ошибка валидации
- `500` - Внутренняя ошибка сервера

---

## 🔄 Пагинация

### Стандартный формат пагинации:
```json
{
  "pagination": {
    "page": 1,
    "per_page": 20,
    "total": 150,
    "total_pages": 8,
    "has_next": true,
    "has_prev": false
  }
}
```

### Параметры запроса:
- `page` - номер страницы (по умолчанию: 1)
- `per_page` - количество элементов на странице (по умолчанию: 20, максимум: 100)
- `sort` - поле для сортировки
- `order` - направление сортировки (asc/desc)

---

*API Спецификация версия 1.0.0*
*Последнее обновление: $(date)*
