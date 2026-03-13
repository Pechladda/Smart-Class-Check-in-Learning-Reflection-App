# AI Usage Report

## Project: Smart Class Check-in & Learning Reflection App

## 1. Overview of AI Tools Used

In this midterm project, I used two main AI tools: **ChatGPT** and **GitHub Copilot** in Visual Studio Code. ChatGPT was used for concept clarification, implementation guidance, and debugging suggestions. GitHub Copilot was used during coding to generate code snippets, suggest Flutter widget structures, and speed up repetitive tasks. These tools supported my development process, but they were not used as a replacement for understanding software engineering concepts.

## 2. How AI Assisted the Development Process

AI tools helped me in several technical areas:

- **Generating Flutter UI structure:** I used AI to draft screen layouts for Home, Check-in, and Finish Class pages using Material UI components. This reduced setup time and helped me keep the interface consistent.
- **QR code scanning implementation:** AI provided sample usage of `mobile_scanner`, including camera preview and scan callback handling.
- **GPS location retrieval:** AI explained permission flow and location retrieval patterns with `geolocator`, including how to handle denied permissions.
- **Firebase integration guidance:** AI gave step-by-step instructions for Firebase setup, Firestore structure planning, and deployment workflow with Firebase Hosting.
- **Debugging errors:** When encountering runtime or permission issues, AI suggested likely causes and troubleshooting steps (for example, platform permission configuration).
- **Improving code structure:** AI suggested cleaner function separation, validation checks, and reusable patterns that made the code easier to read and maintain.

## 3. Human Engineering Judgment

Although AI generated initial code ideas, I reviewed and edited all outputs before using them. I checked logic flow, validated each screen against project requirements, and tested the behavior on actual runs. I also compared generated code with official package documentation when needed. Some AI suggestions were adjusted to match my app architecture, and some were rejected if they did not fit the project scope. This process ensured I understood the implementation, not just copied it.

## 4. Example Prompts Used

- “Create a Flutter Check-in screen with QR scanner, GPS button, and form fields for previous topic, expected topic, and mood score.”
- “How do I request location permission in Flutter using geolocator and handle denied/deniedForever states?”
- “Show a clean way to validate form inputs before saving check-in data.”
- “Why does mobile_scanner not read QR on device? List platform permission checks for Android and iOS.”
- “Explain how to structure Firestore collections for check-in and finish-class reflections.”

## 5. Reflection

This project taught me that AI is most effective as a **learning and productivity assistant**, not an automatic solution. AI helped me move faster and explore implementation options, but meaningful progress still required testing, reading documentation, and engineering judgment. I learned to use AI responsibly by verifying outputs, understanding each component, and making final technical decisions myself. In future projects, I will continue using AI as a support tool while maintaining accountability for code quality, correctness, and ethics.
