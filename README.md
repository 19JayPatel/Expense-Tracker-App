<!-- Project initialized as Expense Tracker App -->

# 💰 Expense Tracker  
### A Flutter-Based Mobile Application for Managing Daily Expenses with Firebase

---

## 🛡️ Badges

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Firestore](https://img.shields.io/badge/Cloud%20Firestore-FF6F00?style=for-the-badge&logo=firebase&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

---

## 🎯 Project Banner

<p align="center">
  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/flutter/flutter-original.svg" width="70"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/firebase/firebase-plain.svg" width="70"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/dart/dart-original.svg" width="70"/>
</p>

---

## 📌 About the Project

**Expense Tracker** is a lightweight **Flutter-based mobile application** designed to help users record, track, and manage their daily expenses efficiently.

The app allows users to add expenses with details such as title, amount, category, and date, and stores data securely in **Firebase Cloud Firestore** with real-time synchronization.

This project focuses on **cross-platform mobile development**, clean UI using **Material 3**, and cloud-backed data management using Firebase.

---

## 🛠️ Tech Stack

| Technology | Description |
|----------|-------------|
| <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/flutter/flutter-original.svg" width="30"/> **Flutter** | Cross-platform UI framework |
| <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/dart/dart-original.svg" width="30"/> **Dart** | Programming language |
| <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/firebase/firebase-plain.svg" width="30"/> **Firebase Firestore** | Cloud NoSQL database |
| **Material 3** | Modern UI design system |
| **FlutterFire CLI** | Firebase configuration |

---

## ✨ Application Features

### 👤 User Features
- Add new expenses (title, amount, category, date)
- Edit and delete expense entries
- View all expenses in real time
- Monthly and total expense summary
- Clean and minimal UI

### ☁️ Cloud Features
- Real-time sync using Firebase Firestore
- Cloud-backed data persistence
- Scalable NoSQL database structure

### 🎨 UI / UX
- Material 3 theming
- Splash screen with custom branding
- Card-based expense list
- Category-based icons and colors

---

## 🗄️ Database Design (Firestore)

- **Database Type:** NoSQL (Cloud Firestore)
- **Collection:** `expenses`

### Document Fields
- `title` – Expense title
- `amount` – Expense amount
- `category` – Expense category
- `date` – Expense date (timestamp)

Firestore provides real-time updates using **streams** and handles scalability automatically.

---

## 📂 Project Folder Structure

```bash
expense_tracker/
├── assets/
│   ├── logo1.png
│   └── logo2.png
│
├── lib/
│   ├── models/
│   │   └── expense.dart
│   │
│   ├── Screen/
│   │   ├── add_expence.dart
│   │   ├── expense_card.dart
│   │   └── SplaceScreen.dart
│   │
│   ├── services/
│   │   └── firestore_services.dart
│   │
│   ├── firebase_options.dart
│   └── main.dart
│
├── android/
├── ios/
├── web/
├── pubspec.yaml
└── README.md

``` 

---

## ⚙️ Installation & Setup Guide
1️⃣ Prerequisites

- Flutter SDK (Dart ≥ 3.x)

- Android Studio / VS Code

- Android Emulator or Physical Device

- Firebase Account

## 2️⃣ Firebase Setup

- Create a Firebase project

- Enable Cloud Firestore

- Configure Flutter app using FlutterFire CLI

- Generate firebase_options.dart

``` bash
dart pub global activate flutterfire_cli
flutterfire configure
```

## 3️⃣ Project Setup

``` bash 
git clone https://github.com/19JayPatel/Expense-Tracker-App.git
cd expense_tracker
flutter pub get
```

## 4️⃣ Run the App

``` bash
flutter run
```

---

## 📸 Splash Screen

![Video](https://github.com/19JayPatel/Expense-Tracker-App/blob/main/output/output.gif)


## 👨‍💻 Author : Jay Sidapara

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/jay-sidapara-b5a131298?utm_source=share_via&utm_content=profile&utm_medium=member_android)
