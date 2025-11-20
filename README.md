**Easacc Test App – Flutter Task**

A simple 3–page Flutter application created as part of the Easacc hiring process.
The app includes social login, settings configuration, mock network device access, and a WebView page based on the saved URL.

---

## 🚀 **Features**

### **1. Login Page**

* UI for:

  * **Google Login**
  * **Facebook Login**
* Uses **mock authentication** (no real Firebase connection required).
* Navigates to **Settings Page** after login.

---

### **2. Settings Page**

This page allows the user to:

#### **A. Enter Website URL**

* Text input for a URL (default: `https://flutter.dev`).
* URL is saved locally.

#### **B. Select Network Device**

* Mock dropdown list containing:

  * WiFi devices
  * Bluetooth devices
  * Printers
* Example items:

  * "Printer A"
  * "Printer B"
  * "Office WiFi"
  * "Bluetooth Speaker"

#### **C. Save Settings**

* Selected URL and device are stored using **SharedPreferences**.

#### **D. Navigate to Web Page**

* Button that redirects to the WebView page.

---

### **3. WebView Page**

* Retrieves stored URL from SharedPreferences.
* Loads the website in a **WebView** (`webview_flutter`).
* Includes a loading indicator until the content finishes loading.

---

## 🏛 **Tech Stack**

* **Flutter 3.x**
* **Dart Null Safety**
* **Riverpod / Bloc** (depending on implementation)
* **SharedPreferences**
* **webview_flutter**
* Clean folder structure (features, widgets, services)

---

## 📁 **Folder Structure**

```
lib/
 ├── features/
 │    ├── login/
 │    ├── settings/
 │    └── webview/
 ├── services/
 │    ├── local_storage_service.dart
 │    └── mock_device_service.dart
 ├── widgets/
 └── main.dart
```

---

## 🛠 **How to Run the App**

1. Install Flutter 3.x+
2. Clone the project
3. Run:

```
flutter pub get
flutter run
```

---

---

## ✨ **Author**

Emmanuel  Aderemi 
