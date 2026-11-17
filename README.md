# 🌍 Smart Tour Partner (Tour Expense Manager)

[![Flutter](https://img.shields.io/badge/Flutter-3.7.2+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-green)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/Developer-atik0ne2042-blue?logo=github)](https://github.com/atik0ne2042)

**Smart Tour Partner** is a modern, high-performance Flutter application built for seamless trip planning, real-time travel expense tracking, and group budget management. Whether you're traveling solo or organizing a group tour, Smart Tour Partner keeps your finances transparent, categorized, and under control.

---

## ✨ Features

- 📊 **Real-Time Expense Dashboard**: 
  - Overview card showing total expenditure and category breakdown.
  - Interactive trip renaming (e.g., *"Cox's Bazar Trip"*).
- 🏷️ **Categorized Expense Tracking**:
  - 🚌 **Transport**: Record transit expenses by vehicle mode (Bus, Train, Flight, Bike, etc.).
  - 🍽️ **Food & Dining**: Log meals, snacks, and group refreshments.
  - 🏨 **Stay & Accommodation**: Keep track of hotel, resort, and guest-house bookings.
  - 🎟️ **Tickets & Entry Passes**: Record tickets for attractions, events, and rides.
- 👥 **Team Member Contribution / Notepad**:
  - Track who paid what during shared group travels.
  - Quick note-taking for trip highlights and pending dues.
- 🌗 **Dynamic Dark & Light Mode**:
  - Fully adaptive modern dark theme (`#050A18`) and clean light theme.
- 💱 **Multi-Currency & Language Support**:
  - Dynamic currency selector (Bangladeshi Taka `৳`, US Dollar `$`, etc.).
  - Multi-language support (English & Bengali).
- 🔒 **Security & Settings**:
  - Biometric / Fingerprint app lock toggle.
  - Data export options.
- 👤 **Customizable Profile**:
  - Dynamic profile management with live state synchronization.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK `^3.7.2`)
- **State Management**: Built-in reactive `ValueNotifier` & `ValueListenableBuilder` architecture for fast, lightweight, and zero-boilerplate updates.
- **UI Design**: Modern Material 3 cards, rounded layouts, and intuitive responsive typography.

---

## 📂 Project Structure

```text
lib/
├── main.dart               # App entry point, global theme & providers
├── homepage.dart           # Dashboard, Bottom Navigation, Settings, Profile & About
├── transport.dart          # Transport expense management & member notepad
├── food.dart               # Food & dining expense tracker
├── stay.dart               # Hotel & accommodation booking tracker
├── tickets.dart            # Tour ticket & entry passes manager
└── all.dart                # Consolidated view of all expense records
```

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.7.2 or later)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / Xcode / VS Code with Flutter extension
- An Android device, iOS simulator, or Chrome browser for testing

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/atik0ne2042/smart-tour-partner.git
   cd smart-tour-partner
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   # Run on connected device / emulator
   flutter run

   # Or run on Chrome
   flutter run -d chrome
   ```

4. **Build APK for Android**:
   ```bash
   flutter build apk --release
   ```

---

## 👨‍💻 Developer & Author

**Atik Hasan**
- **GitHub**: [@atik0ne2042](https://github.com/atik0ne2042)
- **Portfolio**: [atik-hasan.vercel.app](https://atik-hasan.vercel.app)
- **Role**: Software Engineer | Flutter & Full-Stack Developer
- **Institution**: Northern University Bangladesh

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
