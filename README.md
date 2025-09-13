# AI-Powered Decision Support System for Indian Railways

## Overview

This project is a **real-time decision support dashboard for train traffic controllers** in the Indian Railways Madras division. It provides an **interactive section map**, **train schedule monitoring**, **AI-based suggestion assistant**, and **KPIs for train operations**. The system simulates realistic train movements and helps controllers optimize train precedence, rerouting, and handling delays.  

---

## Features

- **Interactive Section Map**: Circuit-board style visualization of Chennai Central → Katpadi section.
- **Train List Panel**: Monitor active trains with ETA, direction, status, and progress.
- **AI Decision Assistant**: Generate, preview, apply, or override AI-based suggestions for train routing and holds.
- **KPIs Panel**: Track number of active trains, delayed trains, and on-time performance.
- **Real-Time Simulation**: Trains move along the section with visual cues for delayed or held trains.
- **Professional UI**: Sidebar navigation, gradient panels, shadows, modern buttons, and notifications.
- **Expandable Architecture**: Easy integration with disruption, KPI, simulation, and training modules.


---

## Technologies Used

- Flutter (Dart)  
- Android / iOS / Web compatible  
- State management: `StatefulWidget` & `setState`  
- UI: Material Design, CustomPainter for track visualization  

---

## Installation & Setup

Follow these steps to run the project on your local machine:

### Prerequisites

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (2.10 or later recommended).
2. Ensure **Dart SDK** is installed.
3. Use **Android Studio**, **VS Code**, or any IDE with Flutter support.
4. Have a connected **Android/iOS emulator or device**.

---

### Steps

1. **Clone the repository**:

git clone <repository-url>
cd <repository-folder>

2. **Install dependencies**:

  flutter pub get
  
3. **Run the app**:
   On connected device or emulator:
     flutter run
   
   For Web:
     flutter run -d chrome
   
4.Explore Dashboard:

Left panel: Train list, hold/reroute actions

Center: Section map with real-time train movement

Right panel: AI decision assistant (apply/override suggestions)

Top KPI strip: Shows active, delayed, and on-time performance

Notifications bell: Disruption page (placeholder) 

---
**How It Works:**

1.Train Simulation:

  Each train has a pos property (0 → 1) indicating its position along the section.

  Periodic timer updates train positions to simulate movement.

  Delayed trains move slower, and held trains stop.

2.AI Suggestions:

  Suggestions are mock-generated using the dashboard button.

  Users can apply, override, or preview each suggestion.

  Suggestion history is maintained with timestamp.

3.Section Map:

  CustomPainter draws tracks, loops, stations, and signals.

  Trains are draggable for rerouting simulations (mock behavior).

  Stations show signal status based on train occupancy.

4.KPIs:

  Active trains, delayed trains, and on-time percentage are displayed.

  KPI cards update dynamically based on mock train data.

---

**Future Enhancements:**

Integrate real train schedule APIs.

AI suggestions using optimization algorithms.

Real disruption handling (delays, maintenance, accidents).

Notifications and email alerts for controllers.

Multi-section view across entire Indian Railways network.
