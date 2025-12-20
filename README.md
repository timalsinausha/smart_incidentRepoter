# Smart Incident Reporter

A Flutter mobile application to **create, manage, and track incident reports**. Users can register, upload incidents with priority, attach images, and view incident details. The app uses **Firebase** for authentication, Firestore for data storage, and **Firebase Storage** for images. **Riverpod** is used for state management, and **Beamer** is used for navigation.

---

## Features

- Email/password registration and login using Firebase Authentication  
- User profile management: update name and profile image  
- Create, view, update, and delete incidents  
- Incident details: title, type, priority, description, image, timestamp  
- Image upload to Firebase Storage  
- Incident types fetched from an API  
- Priority levels: Low, Medium, High  
- Visual differentiation of incident types and priority levels using icons and colors  

---

## Image Upload

- Users can select images from **camera or gallery**.  
- Images are uploaded to a **cloud storage service** (Cloudinary) securely.  
- The uploaded image URL is stored in **Firebase Firestore** along with the incident or user profile data.  
- This allows images to be accessible across devices and sessions without exposing sensitive credentials.

---
## Firebase Setup

1. Create a Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/).
2. Add an Android and/or iOS app to the project.
3. Download the configuration files:
   - For Android: `google-services.json` → place in `android/app/`
   - For iOS: `GoogleService-Info.plist` → place in `ios/Runner/`
4. Enable **Authentication** in Firebase:
   - Go to Authentication → Sign-in method → Enable Email/Password
5. Create Firestore database:
   - Go to Firestore → Create database → Start in production or test mode
6. Enable Firebase Storage (for image uploads)
   - Go to Storage → Get started → Set up rules
7. Update your Flutter project:
   ```bash
   flutter pub get
   flutter run

---
## Incident Type API Source

- The app fetches incident types from a REST API using MockAPI.
- API endpoint used:https://6943af4769b12460f3159d45.mockapi.io/incidentTypes
- This API provides the list of incident types such as:Theft, Fire, Accident, Natural Disaster, Medical Emergency.
- These incident types are displayed dynamically in the incident creation dropdown.


---
## Screenshots

Login Screen:  
![Login Screen](assets/images/login.jpg)

Register Screen:  
![Register Screen](assets/images/register.jpg)

Home Screen:  
![Home Screen](assets/images/homepage.jpg)

Details Screen:  
![Details Screen](assets/images/details.jpg)

Add Incident Screen:  
![Add Incident Screen](assets/images/addinc.jpg)

Update Incident Screen:  
![Update Incident Screen](assets/images/updateincident.jpg)

Delete Incident Screen:  
![Delete Incident Screen](assets/images/delete.jpg)

Profile Screen:  
![Profile Screen](assets/images/profile.jpg)

---

## Flutter Version

```text
Flutter 3.24.3 • Dart 3.5.5
