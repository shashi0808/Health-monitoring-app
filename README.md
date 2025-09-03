# Soil Health Monitoring App

A Flutter application that connects to Bluetooth devices to monitor soil temperature and moisture readings, storing data in Firebase Firestore with user authentication.

## Features

- **Bluetooth Integration**: Connects to Bluetooth devices for sensor data collection (mock implementation included)
- **Firebase Authentication**: Email/password login and registration
- **Firebase Firestore**: Real-time data storage and retrieval
- **Interactive Charts**: Visual representation of temperature and moisture trends using FL Chart
- **Clean UI**: Intuitive interface with Test and Reports functionality
- **History Tracking**: View past readings with timestamps and health status indicators

## Screenshots

The app includes:
- Login/Signup screen with Firebase authentication
- Home screen with Test and Reports buttons
- Real-time display of latest readings
- History screen with interactive charts and reading list
- Bluetooth connection status indicator

## Requirements

- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android SDK for Android builds
- Firebase project with Authentication and Firestore enabled

## Setup Instructions

### 1. Flutter Environment Setup

Ensure Flutter is installed and properly configured:

```bash
flutter doctor
```

### 2. Clone and Install Dependencies

```bash
git clone <repository-url>
cd Health-monitoring-app
flutter pub get
```

### 3. Firebase Configuration

#### Create a Firebase Project:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable Authentication (Email/Password provider)
4. Enable Firestore Database
5. Set up Firestore rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /sensor_readings/{document} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

#### Configure Firebase for your platforms:

**Android:**
1. Add your Android app in Firebase Console
2. Download `google-services.json`
3. Place it in `android/app/` directory
4. Update `android/app/build.gradle`:

```gradle
dependencies {
    implementation 'com.google.firebase:firebase-analytics'
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
}
```

**iOS (Optional):**
1. Add your iOS app in Firebase Console
2. Download `GoogleService-Info.plist`
3. Add to `ios/Runner/` directory

#### Update Firebase Configuration:
Edit `lib/firebase_options.dart` with your actual Firebase project credentials:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-actual-api-key',
  appId: 'your-actual-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.appspot.com',
);
```

### 4. Android Permissions

The app requires Bluetooth permissions. Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```

### 5. Run the Application

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/
│   └── sensor_reading.dart   # Data model for sensor readings
├── providers/
│   ├── auth_provider.dart    # Authentication state management
│   └── sensor_provider.dart  # Sensor data state management
├── screens/
│   ├── auth_screen.dart      # Login/Signup UI
│   ├── home_screen.dart      # Main app screen
│   └── history_screen.dart   # Historical data view
└── services/
    ├── bluetooth_service.dart # Bluetooth communication (mock)
    └── firestore_service.dart # Firebase Firestore operations
```

## Bluetooth Implementation Notes

### Current Implementation (Mock)
The app currently uses mock Bluetooth data that generates random temperature (15-35°C) and moisture (20-80%) readings. This approach allows for:
- Complete app functionality without hardware
- Easy testing and development
- Structured implementation for real device integration

### Real Device Integration
To integrate with actual Bluetooth devices:

1. **Update `BluetoothService`**: Replace mock methods with actual Bluetooth communication
2. **Device Scanning**: Implement real device discovery
3. **Data Parsing**: Parse actual sensor data format
4. **Error Handling**: Add proper connection error handling

Example real device integration structure:
```dart
// Replace mock implementation in bluetooth_service.dart
Future<Map<String, double>> getReading() async {
  // Real implementation would:
  // 1. Send command to Bluetooth device
  // 2. Read response data
  // 3. Parse sensor values
  // 4. Return formatted data
}
```

## App Usage

### 1. Authentication
- Open the app and create an account or sign in
- Use email/password authentication

### 2. Taking Readings
- Ensure Bluetooth connection (shows status on home screen)
- Tap "Test" button to fetch new sensor reading
- Data automatically saves to Firebase Firestore

### 3. Viewing Reports
- Tap "Reports" to see latest reading details
- Use "View History" to see all past readings
- Switch between temperature and moisture charts

### 4. Data Visualization
- Interactive line charts show trends over time
- Color-coded health status (Good/Fair/Poor) based on optimal soil conditions
- Detailed list view with timestamps

## Dependencies

- `firebase_core: ^2.24.2` - Firebase core functionality
- `firebase_auth: ^4.15.3` - User authentication
- `cloud_firestore: ^4.13.6` - Database operations
- `provider: ^6.1.1` - State management
- `fl_chart: ^0.66.0` - Chart visualization
- `flutter_bluetooth_serial: ^0.4.0` - Bluetooth communication
- `permission_handler: ^11.2.0` - Handle app permissions
- `intl: ^0.19.0` - Date formatting

## Building APK

To create a release APK:

```bash
flutter build apk --release
```

The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

## Assumptions Made

1. **Bluetooth Device Protocol**: Assumed generic device emitting simple temperature/moisture values
2. **Data Format**: Expected numeric temperature (°C) and moisture (%) values
3. **Connection Model**: Single device connection at a time
4. **Soil Health Criteria**: 
   - Good: 20-30°C temperature, 40-70% moisture
   - Fair: 15-35°C temperature, 30-80% moisture
   - Poor: Outside above ranges
5. **User Data**: Each user's readings are isolated and private
6. **Internet Connectivity**: Required for Firebase operations

## Troubleshooting

### Common Issues:

1. **Firebase Connection**: Ensure `google-services.json` is properly configured
2. **Bluetooth Permissions**: Grant location permissions on Android
3. **Build Errors**: Run `flutter clean` and `flutter pub get`
4. **Authentication Issues**: Check Firebase project configuration

### Debug Mode:
```bash
flutter run --debug
flutter logs
```

## Future Enhancements

- Offline data caching
- Real-time data sync across devices
- Push notifications for alerts
- Export data to CSV/PDF
- Multi-device support
- Advanced analytics and recommendations

## License

This project is developed as part of an assignment and is intended for educational purposes.