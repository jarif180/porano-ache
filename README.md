# 📚 পড়ানো আছে (Porano Ache)

A cross-platform mobile app for private tutors in Bangladesh to manage their tuition business.

## Features

### 🧑‍🏫 Tutor Portal
- **Schedule Management** — Weekly timetable with conflict detection
- **Student Management** — Add, edit, and track students
- **Attendance Tracking** — One-tap daily attendance marking
- **Payment Tracking** — Cash + SSLCommerz (bKash, Nagad, Cards)
- **Makeup Classes** — Reschedule missed classes
- **Progress Notes** — Track student performance with ratings
- **Push Notifications** — Class reminders and payment alerts

### 🎓 Student/Parent Portal
- View own schedule, attendance, and day count
- Track payment status and pay online
- View progress notes and ratings

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Riverpod |
| Backend | Firebase (Auth, Firestore, FCM) |
| Payment | SSLCommerz |
| Architecture | Feature-First Clean Architecture |

## Localization

- 🇧🇩 বাংলা (Bangla)
- 🇬🇧 English

## Getting Started

### Prerequisites
- Flutter SDK 3.x+
- Android Studio / Android SDK
- Firebase CLI
- Node.js

### Setup
```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/porano-ache.git
cd porano-ache

# Install dependencies
flutter pub get

# Configure Firebase
flutterfire configure

# Run the app
flutter run
```

## Project Structure
```
lib/
├── core/           # Shared utilities, theme, router
├── features/       # Feature modules (auth, students, schedule, etc.)
├── l10n/           # Localization (Bangla + English)
└── main.dart       # Entry point
```

## License

This project is private and proprietary.

---

**পড়ানো আছে** — _Because every tutor deserves a better way to manage._
