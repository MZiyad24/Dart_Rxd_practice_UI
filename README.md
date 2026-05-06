# RX Dart Restaurant & Café Finder

A Flutter mobile application built using **RxDart** and **API Integration** that allows users to authenticate, browse restaurants/cafés, search for products, and view results in both list and map views.

---

# 📌 Features

## 🔐 Authentication

### Signup Screen
The signup screen includes the following validations:

- Name (required)
- Gender (optional radio buttons)
- Email (required + valid email format)
- Level (optional dropdown: 1,2,3,4)
- Password (required + minimum 8 characters)
- Confirm Password:
  - required
  - minimum 8 characters
  - must match password

### Login Screen
Users can log into the application using:
- Email
- Password

### Authentication Flow
- API-based authentication
- Token persistence using local storage
- Navigation to home screen after successful login/signup

---

# 🍽 Restaurants & Cafés

Users can:
- View a list of all restaurants/cafés
- Open a restaurant/café details screen
- Browse products available in each restaurant/café

---

# 🔍 Product Search

The application provides a reactive product search system using **RxDart**.

## Search Features

- Search for products
- View restaurants/cafés providing the selected product
- Reactive search with:
  - debounce
  - stream handling
  - automatic UI updates

---

# 🗺 Map & Directions

Users can:
- Switch between:
  - List View
  - Map View
- View nearby restaurants/cafés on Google Maps
- Get:
  - Distance
  - Directions
  - Current location tracking

---

# 🧠 RxDart Usage

RxDart is used for:

- Form validation
- Reactive UI state management
- Search stream handling
- Debouncing search requests
- Combining streams
- Managing asynchronous events

## Main RxDart Components

- `BehaviorSubject`
- `combineLatest`
- `debounceTime`
- `switchMap`

---

# 🏗 Project Architecture

```text
lib/
│
├── models/        # Data models / DTOs
├── services/      # API services
├── blocs/         # RxDart business logic
├── screens/       # UI screens
├── widgets/       # Reusable widgets
└── utils/         # Helpers / constants
```

---

# 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  rxdart: ^0.27.7
  http: ^1.2.1
  shared_preferences: ^2.2.2

  # Optional
  google_maps_flutter: ^2.6.0
  geolocator: ^12.0.0
```

---

# 🔄 Application Flow

```text
Splash Screen
      ↓
Login / Signup
      ↓
Home Screen
      ↓
Restaurant Details
      ↓
Search Products
      ↓
Results (List / Map)
      ↓
Directions Screen
```

---

# 🛠 Technologies Used

- Flutter
- Dart
- RxDart
- REST APIs
- Shared Preferences
- Google Maps API
- Geolocator

---

# 🚀 Getting Started

## 1. Clone Repository

```bash
git clone <repository-url>
```

---

## 2. Install Dependencies

```bash
flutter pub get
```

---

## 3. Run Application

```bash
flutter run
```

---

# 📱 Screens

- Login Screen
- Signup Screen
- Restaurants/Cafés List
- Products List
- Product Search
- Search Results
- Map View
- Directions Screen

---

# 🎯 Learning Objectives

This project demonstrates:

- RxDart stream management
- BLoC architecture basics
- API integration in Flutter
- Reactive programming concepts
- Real-time validation
- Search optimization using debounce
- State management using streams

---
