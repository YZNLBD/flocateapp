LocateApp - Real-Time GPS Tracking System
LocateApp is a robust, production-ready mobile solution designed for monitoring the real-time location of objects or individuals using IoT-enabled tracking hardware. By leveraging Clean Architecture, the project ensures high maintainability and scalability .

---

🚀 Features
p-Real-Time Tracking: Seamlessly monitor device movements on a live map with latency under 2 seconds.

-Geofencing (Safe Zones): Define virtual boundaries on the map. Receive instant push notifications via Firebase Cloud Messaging (FCM) if a device exits the designated area.

-Device Management: Comprehensive dashboard to monitor battery levels, connection quality, and "last seen" timestamps.

-Security & Auth: Secure user registration and login powered by Firebase Authentication.

-Lost Mode: Integrated "Play Sound" feature to locate nearby devices and a "Lost Mode" to lock device details.

---

🛠 Tech Stack

Frontend: 

Flutter (Dart) - targeting both iOS and Android from a single codebase.

Backend:

   _Firebase Realtime Database: For high-speed, live coordinate updates.
   
   _Cloud Firestore: For structured storage of user profiles and device metadata.

   -Mapping: OpenStreetMap (OSM) via the flutter_map package (an open-source, cost-effective alternative to Google Maps).

   -State Management: Provider.

---

📐 Architecture & Logic
The project follows Clean Architecture to separate business logic from the UI.

-Location Logic: Uses the geolocator package to stream GPS coordinates at optimized intervals to balance accuracy and battery consumption.

-Mathematical Models: Implements the Haversine Formula to calculate the precise "great-circle" distance between two coordinates for accurate Geofence triggering.

---

📸 Screenshots

---

🧪 Testing Status
The application has undergone rigorous testing, including:

-Authentication Flow: Success in login/registration and password reset scenarios.

-Simulation: Real-time updates were verified using dummy data to simulate GPS movement.

-Performance: Verified stability under low-bandwidth conditions and background processing.
