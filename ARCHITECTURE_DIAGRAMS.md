# Champion Fitness Gym App - Архитектурные диаграммы

## 🏗️ Общая архитектура системы

```
┌─────────────────────────────────────────────────────────────────┐
│                    Champion Fitness Gym App                    │
├─────────────────────────────────────────────────────────────────┤
│  📱 Flutter Mobile App (iOS/Android)                          │
│  ├── 🎨 UI Layer (Pages, Components, Themes)                  │
│  ├── 🔧 Business Logic (State Management, Services)           │
│  ├── 💾 Local Storage (SharedPreferences, SQLite)             │
│  └── 🌐 Network Layer (HTTP Client, API Services)             │
├─────────────────────────────────────────────────────────────────┤
│  🔗 API Gateway / Load Balancer                               │
├─────────────────────────────────────────────────────────────────┤
│  🏢 Backend Services (CRM Integration)                        │
│  ├── 👤 User Management Service                               │
│  ├── 🎫 Membership Service                                    │
│  ├── 💪 Workout Booking Service                               │
│  ├── 📊 Analytics Service                                     │
│  ├── 🔔 Notification Service                                  │
│  ├── 🤖 AI Assistant Service                                  │
│  └── 💳 Payment Service                                       │
├─────────────────────────────────────────────────────────────────┤
│  💾 Databases                                                 │
│  ├── 👥 Users DB (PostgreSQL)                                │
│  ├── 🎫 Memberships DB (PostgreSQL)                          │
│  ├── 💪 Bookings DB (PostgreSQL)                             │
│  ├── 📊 Analytics DB (MongoDB)                                │
│  └── 🔔 Notifications DB (Redis)                              │
└─────────────────────────────────────────────────────────────────┘
```

## 📱 Структура Flutter приложения

```
lib/
├── main.dart                           # 🚀 Entry Point
├── modules/
│   ├── layout.dart                     # 🏗️ Main Layout
│   ├── layout/
│   │   └── footbar.dart               # 📱 Bottom Navigation
│   ├── theme/
│   │   └── colors.dart                # 🎨 Theme System
│   ├── components/
│   │   ├── animated_tap.dart          # ✨ Tap Animations
│   │   └── animated_button.dart       # 🔘 Button Animations
│   └── pages/                         # 📄 All App Pages
│       ├── home.dart                  # 🏠 Home Page
│       ├── profile.dart               # 👤 Profile Page
│       ├── stats.dart                 # 📊 Statistics Page
│       ├── workouts.dart              # 💪 Workouts Page
│       ├── ai_assistant.dart          # 🤖 AI Assistant
│       ├── clubs_catalog.dart         # 🏢 Clubs Catalog
│       ├── trainers_catalog.dart      # 👨‍💼 Trainers Catalog
│       ├── notifications_settings.dart # 🔔 Notifications
│       ├── security_settings.dart     # 🔒 Security Settings
│       └── promotions_page.dart       # 🎯 Promotions
└── assets/                            # 🎨 Static Assets
    ├── fonts/                         # 🔤 Custom Fonts
    ├── icons/                         # 🎯 SVG Icons
    └── images/                        # 🖼️ Images
```

## 🔄 Поток данных пользователя

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│   👤 User   │───▶│  📱 Flutter  │───▶│  🌐 API     │
│             │    │    App       │    │  Gateway    │
└─────────────┘    └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  💾 Local    │    │  🏢 Backend │
                   │  Storage     │    │  Services   │
                   └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  🔄 Cache    │    │  💾 Database│
                   │  (Memory)    │    │  (Persistent)│
                   └──────────────┘    └─────────────┘
```

## 🎯 Навигация между страницами

```
                    ┌─────────────┐
                    │  🏠 Home    │
                    └─────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  📊 Stats   │    │  💪 Workouts│    │  👤 Profile │
└─────────────┘    └─────────────┘    └─────────────┘
        │                  │                  │
        │                  │                  │
        ▼                  ▼                  ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  📈 Charts  │    │  📅 Booking │    │  ⚙️ Settings│
└─────────────┘    └─────────────┘    └─────────────┘
                           │                  │
                           ▼                  ▼
                   ┌─────────────┐    ┌─────────────┐
                   │  🤖 AI Chat │    │  🔔 Notifications│
                   └─────────────┘    └─────────────┘
```

## 🔐 Система аутентификации

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│   👤 User   │───▶│  📱 Login    │───▶│  🔐 Auth    │
│   Credentials│    │    Screen    │    │  Service    │
└─────────────┘    └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  🎫 JWT      │    │  👤 User    │
                   │  Tokens      │    │  Profile    │
                   └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  🔄 Token    │    │  🎫 Membership│
                   │  Refresh     │    │  Status     │
                   └──────────────┘    └─────────────┘
```

## 📊 Система аналитики

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│  📱 App     │───▶│  📊 Event    │───▶│  🏢 Analytics│
│  Events     │    │  Tracker     │    │  Service    │
└─────────────┘    └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  💾 Local    │    │  📈 Reports │
                   │  Analytics   │    │  & Insights │
                   └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  🔄 Sync     │    │  📊 Dashboard│
                   │  (Offline)   │    │  (Admin)    │
                   └──────────────┘    └─────────────┘
```

## 🎫 Система бронирования

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│  👤 User    │───▶│  📅 Class    │───▶│  🏢 Booking │
│  Selects    │    │  Selection   │    │  Service    │
└─────────────┘    └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  ✅ Check    │    │  📧 Send    │
                   │  Availability│    │  Confirmation│
                   └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  💳 Process  │    │  📱 Push    │
                   │  Payment     │    │  Notification│
                   └──────────────┘    └─────────────┘
```

## 🔔 Система уведомлений

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│  🎯 Event   │───▶│  🔔 Notification│───▶│  📱 Push    │
│  Trigger    │    │  Service      │    │  Service    │
└─────────────┘    └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  📧 Email    │    │  📱 Mobile  │
                   │  Service     │    │  App        │
                   └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  📱 SMS      │    │  🔔 In-App  │
                   │  Service     │    │  Notification│
                   └──────────────┘    └─────────────┘
```

## 💾 Структура базы данных

```
┌─────────────────────────────────────────────────────────────┐
│                    PostgreSQL Database                      │
├─────────────────────────────────────────────────────────────┤
│  👥 users                    │  🎫 memberships             │
│  ├── id (PK)                 │  ├── id (PK)                │
│  ├── name                    │  ├── user_id (FK)           │
│  ├── email                   │  ├── type                   │
│  ├── phone                   │  ├── club_id (FK)           │
│  ├── avatar_url              │  ├── start_date             │
│  ├── created_at              │  ├── expires_date           │
│  └── updated_at              │  └── status                 │
├─────────────────────────────────────────────────────────────┤
│  💪 classes                  │  📅 bookings                │
│  ├── id (PK)                 │  ├── id (PK)                │
│  ├── title                   │  ├── user_id (FK)           │
│  ├── category                │  ├── class_id (FK)          │
│  ├── trainer_id (FK)         │  ├── datetime               │
│  ├── datetime                │  ├── status                 │
│  ├── duration_minutes        │  └── created_at             │
│  ├── max_participants        │                             │
│  └── price                   │  🎪 events                  │
├─────────────────────────────────────────────────────────────┤
│  ├── id (PK)                 │  🏢 clubs                   │
│  ├── title                   │  ├── id (PK)                │
│  ├── description             │  ├── name                   │
│  ├── organizer               │  ├── address                │
│  ├── datetime                │  ├── phone                  │
│  ├── location                │  ├── working_hours          │
│  └── max_participants        │  └── services               │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 API Integration Flow

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│  📱 Flutter │───▶│  🌐 HTTP     │───▶│  🏢 Backend │
│  App        │    │  Client      │    │  API        │
└─────────────┘    └──────────────┘    └─────────────┘
        │                  │                    │
        ▼                  ▼                    ▼
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│  🔄 State   │    │  📦 Request  │    │  🔐 Auth    │
│  Management │    │  Builder     │    │  Middleware │
└─────────────┘    └──────────────┘    └─────────────┘
        │                  │                    │
        ▼                  ▼                    ▼
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│  💾 Cache   │    │  📊 Response │    │  💾 Database│
│  Layer      │    │  Parser      │    │  Query      │
└─────────────┘    └──────────────┘    └─────────────┘
```

## 🎨 UI/UX Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    UI Layer Architecture                    │
├─────────────────────────────────────────────────────────────┤
│  📱 Pages (Screens)                                        │
│  ├── 🏠 HomePage                                           │
│  ├── 👤 ProfilePage                                        │
│  ├── 📊 StatsPage                                          │
│  ├── 💪 WorkoutsPage                                       │
│  └── ... (other pages)                                     │
├─────────────────────────────────────────────────────────────┤
│  🧩 Components (Reusable Widgets)                          │
│  ├── ✨ AnimatedTap                                        │
│  ├── 🔘 CustomButton                                       │
│  ├── 📊 StatCard                                           │
│  └── ... (other components)                                │
├─────────────────────────────────────────────────────────────┤
│  🎨 Theme System                                           │
│  ├── 🌙 Dark Theme                                         │
│  ├── ☀️ Light Theme                                        │
│  ├── 🎨 Color Palette                                      │
│  └── 🔤 Typography                                         │
├─────────────────────────────────────────────────────────────┤
│  📱 Layout System                                          │
│  ├── 🏗️ Main Layout                                        │
│  ├── 📱 Bottom Navigation                                  │
│  ├── 📊 App Bar                                            │
│  └── 📱 Responsive Design                                  │
└─────────────────────────────────────────────────────────────┘
```

## 🔧 State Management Flow

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│  👤 User    │───▶│  📱 UI       │───▶│  🔄 Provider│
│  Action     │    │  Event       │    │  State      │
└─────────────┘    └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  🌐 API      │    │  💾 Local   │
                   │  Call        │    │  Storage    │
                   └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  📊 Update   │    │  🔄 Cache   │
                   │  State       │    │  Update     │
                   └──────────────┘    └─────────────┘
```

## 📊 Performance Optimization

```
┌─────────────────────────────────────────────────────────────┐
│                Performance Optimization                     │
├─────────────────────────────────────────────────────────────┤
│  🚀 App Performance                                         │
│  ├── 📱 Lazy Loading (Pages)                               │
│  ├── 🖼️ Image Optimization                                 │
│  ├── 💾 Memory Management                                  │
│  └── 🔄 State Optimization                                 │
├─────────────────────────────────────────────────────────────┤
│  🌐 Network Performance                                     │
│  ├── 📦 Request Batching                                    │
│  ├── 💾 Response Caching                                    │
│  ├── 🔄 Offline Support                                     │
│  └── 📊 Data Compression                                    │
├─────────────────────────────────────────────────────────────┤
│  💾 Database Performance                                    │
│  ├── 🔍 Query Optimization                                  │
│  ├── 📊 Indexing Strategy                                   │
│  ├── 🔄 Connection Pooling                                  │
│  └── 📈 Monitoring                                          │
└─────────────────────────────────────────────────────────────┘
```

---

*Архитектурные диаграммы версия 1.0.0*
*Последнее обновление: $(date)*
