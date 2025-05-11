# Quick Visit - Service Reservation System

Quick Visit is a Flutter-based medical appointment booking application that allows users to easily schedule and manage their medical appointments.

# 📱 Quick Visit - Service Reservation System

**Quick Visit** is a Flutter-based medical appointment booking application that simplifies the process of scheduling and managing appointments with healthcare professionals.

![Flutter](https://img.shields.io/badge/Flutter-%5E3.10-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/Backend-Firebase-F5820D?logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blueviolet)

---

## Business Understanding

Quick Visit is a specialized appointment booking system designed to streamline the process of connecting patients with healthcare specialists. The app aims to simplify the healthcare appointment booking process by providing a centralized platform where users can discover specialists, book appointments based on real-time availability, and manage their medical consultations efficiently. It addresses the common pain points of traditional appointment booking systems by offering a digital solution with instant confirmation and flexible management options.

## Setup Instructions

### 1. Prerequisites:

- Flutter SDK (latest stable version)
- Firebase CLI
- Android Studio / VS Code
- Git

### 2. Clone the Repository

```bash
git clone https://github.com/A7medabdelaty/quick_visit
cd quick_visit
flutter pub get
```

## Features

### Appointment Management

- View upcoming and past appointments in separate tabs
- Book new appointments with preferred doctors
- Manage existing appointments (with restrictions)
  - Cancellation requires at least 24 hours notice before appointment time
  - Rescheduling must be done at least 24 hours before the original appointment
  - Late cancellations or no-shows may affect future booking privileges
- Track appointment status

### 👨‍⚕️ Doctor Discovery

- Browse and search doctors by specialty
- View detailed doctor profiles
- Filter by ratings and availability

### 🔐 User Authentication

- Secure login/logout system
- Profile and session management

### 💳 Payment Processing

- Display consultation fees
- Mock payment confirmation system

---

## 🧠 Technical Implementation

### State Management

- Uses **BLoC** pattern
- Clean architecture via **Repository pattern**

### Backend & Data

- Firebase Authentication for user auth
- Cloud Firestore for appointments, doctor data
- Real-time data updates

### UI/UX

- Built using **Material Design**
- Custom widgets for appointments and doctor cards
- Responsive layouts with tab navigation

---

## 📁 Project Structure

```bash
lib/
├── core/
│   ├── constants/
│   ├── services/
│   ├── theme/
│   └── widgets/
└── features/
    ├── appointments/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── auth/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── doctors/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── home/
        ├── data/
        ├── domain/
        └── presentation/
```

---

## Known Limitations

1. **Offline Support**: Currently requires active internet connection
2. **Notification System**: Basic implementation without push notifications
3. **Payment Integration**: Mock payment flow without real payment processing
4. **Data Caching**: Limited local data persistence

## Appointment Management Restrictions

### Cancellation Policy

- Appointments can only be cancelled at least 24 hours before the scheduled time
- Late cancellations are not permitted through the app
- For emergency cancellations within 24 hours, please contact the clinic directly

### Rescheduling Rules

- Rescheduling requires minimum 24-hour notice
- New appointment time must be within the doctor's available slots
- Limited to one reschedule per appointment

### No-Show Policy

- Missed appointments without proper cancellation will be recorded
- Multiple no-shows may result in booking restrictions
- Users are encouraged to manage their appointments responsibly

### 🎥 Video Walkthrough

[▶️ Watch Demo on GoogleDrive](https://drive.google.com/file/d/196rKZ7Y7q1L3eDGIYTQ7mA-iEdP5n80T/view?usp=sharing)
