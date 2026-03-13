# Product Requirements Document (PRD)

## 1. Executive Summary

**Project Name:** Smart Class Check-in & Learning Reflection App  
**Project Type:** University Midterm Mobile Application

Smart Class is a Flutter mobile app that helps students confirm class attendance and submit learning reflections. The app uses QR code scanning and GPS location verification to support attendance reliability. It also captures short reflections before and after class to improve learning awareness and course feedback quality.

The solution includes three main screens: Home, Check-in (Before Class), and Finish Class (After Class). Student submissions are stored in Firebase Firestore, and deployment is planned via Firebase Hosting (for web access and project distribution).

---

## 2. Problem Statement

Traditional attendance methods (manual sign-in or verbal roll call) are slow, error-prone, and easy to abuse. At the same time, students often finish class without recording what they expected to learn or what they actually learned.

This project addresses two gaps:
- **Attendance integrity:** Verify presence using both QR code and GPS location.
- **Learning reflection:** Collect simple, structured feedback before and after class.

---

## 3. Goals and Objectives

### Primary Goals
- Build a functional mobile app for class check-in and class-end reflection.
- Improve attendance accuracy with QR + GPS verification.
- Encourage students to reflect on class expectations and outcomes.

### Measurable Objectives
- Students can complete check-in in under 1 minute.
- 100% of submitted records include QR scan result and GPS coordinates.
- Store all check-in and finish-class records in a centralized cloud database (Firestore).

---

## 4. Target Users

- **Primary Users:** University students attending scheduled classes.
- **Secondary Users:** Instructors (indirectly, through attendance and feedback data review).

User characteristics:
- Uses Android/iOS smartphones.
- Needs quick workflow before and after class.
- Prefers clear, minimal UI and low data-entry effort.

---

## 5. Key Features

### Home Screen
- Button: **Check-in to Class**
- Button: **Finish Class**

### Check-in Screen (Before Class)
- Scan class QR code.
- Get current GPS location (latitude, longitude).
- Input: previous class topic.
- Input: expected topic for today.
- Mood selector (scale 1–5).
- Submit data to Firebase Firestore.

### Finish Class Screen (After Class)
- Scan class QR code.
- Get current GPS location.
- Input: what was learned today.
- Input: class feedback.
- Save data to Firebase Firestore.

---

## 6. User Flow

1. Student opens app and lands on **Home Screen**.
2. Student selects one action:
   - **Check-in to Class** (before class), or
   - **Finish Class** (after class).
3. Student scans QR code.
4. Student grants location permission and captures GPS location.
5. Student fills required reflection fields.
6. Student taps submit/save.
7. App validates required fields and sends data to Firebase Firestore.
8. App shows success message and returns to Home Screen.

---

## 7. Data Fields

### A) Check-in Record (Before Class)
- `timestamp` (DateTime)
- `student_id` (String, optional for midterm scope)
- `class_id` (String or derived from QR)
- `qr_code` (String)
- `latitude` (Double)
- `longitude` (Double)
- `previous_topic` (String)
- `expected_topic` (String)
- `mood_score` (Integer: 1–5)

### B) Finish Class Record (After Class)
- `timestamp` (DateTime)
- `student_id` (String, optional for midterm scope)
- `class_id` (String or derived from QR)
- `qr_code` (String)
- `latitude` (Double)
- `longitude` (Double)
- `learned_today` (String)
- `feedback` (String)

---

## 8. System Architecture Overview

### Frontend
- Flutter app with Material UI components.
- Three screens with form validation and navigation.
- Device services integration:
  - Camera for QR scanning
  - GPS for location capture

### Backend / Cloud
- Firebase Firestore stores structured records:
  - `checkins` collection
  - `finish_classes` collection
- Firebase Hosting used for web deployment and demo distribution.

### High-Level Data Flow
1. User inputs + device data are collected in Flutter.
2. App validates required fields.
3. App writes record to Firestore.
4. Firestore persists data for future reporting/analytics.

---

## 9. Technology Stack

- **Framework:** Flutter
- **UI:** Material UI (Material Design widgets)
- **QR Scanner:** `mobile_scanner`
- **Location Service:** `geolocator`
- **Database:** Firebase Firestore
- **Deployment:** Firebase Hosting

---

## 10. Future Improvements

- Add university login/authentication (Firebase Authentication).
- Restrict check-in by classroom geofence radius.
- Instructor dashboard for attendance and reflection analytics.
- Export attendance and feedback reports (CSV/PDF).
- Push notifications for class reminders.
- Offline mode with queued sync when internet reconnects.

---

**End of PRD**
