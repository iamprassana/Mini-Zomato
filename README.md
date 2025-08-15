### Mini-Zomato

This project uses the Bloc State Management tool for scalability and separation of concerns.

### Bloc Architecture Overview:

    1) UI Layer:
          This only handles the presentation part of the application. It listens to the changes in the state and renders the UI based on that state.
    2) BLoc Layer:
          This layer handles all the business logic-related parts of the application and communicates with repositories.
    3) Repository Layer:
          This layer acts as the bridge between the bloc and the data layer of the application
    4) Data Layer:
          In this layer, the information is fetched from Firebase and stored.

  ### Firebase
      Firebase has been used to store information about the user and store the data.
      Firebase authentication has been used for authentication.
  Restaurant data is mock data and stored in the app for the time being.

  ### Folder Structure:
      bloc
      data
      repository
      presentation

  ## 🚀 Setup & Run Instructions

### 1️⃣ Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed
- [Dart SDK](https://dart.dev/get-dart) installed (comes with Flutter)
- An editor like **VS Code** or **Android Studio**
- Firebase required
---

### 2️⃣ Clone the Repository
```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

### Run instruction
  - flutter pub get
  - flutter run
  - flutter build apk -release (If u want release version)


          ┌───────────────────┐
          │       UI Layer     │
          │ (Flutter Widgets)  │
          └─────────┬─────────┘
                    │ User Events
                    ▼
           ┌───────────────────┐
           │       BLoC         │
           │ (Business Logic)   │
           └─────────┬─────────┘
                    │ Emits States
                    ▼
          ┌───────────────────┐
          │   Repository       │
          │ (Data Handling)    │
          └─────────┬─────────┘
                    │ API/DB Calls
                    ▼
        ┌────────────────────────────┐
        │ Data Sources (API/Firebase)│
        └────────────────────────────┘



  
      
