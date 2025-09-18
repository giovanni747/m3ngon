# M3NGON 📚

A modern Flutter-based manga discovery and social platform that combines the power of MyAnimeList API with Firebase backend services to create an engaging community for manga enthusiasts.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## ✨ Features

### 🔍 **Manga Discovery**
- **Search & Browse**: Find manga using MyAnimeList's comprehensive database
- **Rankings**: Explore top-rated manga across different categories (all, manhwa, manhua, novels)
- **Detailed Information**: View synopsis, genres, ratings, and cover art
- **Recommendations**: Get personalized suggestions based on your preferences

### 👥 **Social Features**
- **User Profiles**: Create and customize your profile with photos and bio
- **Social Feed**: Share posts about your favorite manga
- **Follow System**: Connect with other manga enthusiasts
- **Like & Interaction**: Engage with community content
- **Friends List**: Manage your social connections

### 🤖 **AI Assistant**
- **Gemini Integration**: Chat with an AI assistant for manga recommendations
- **Smart Suggestions**: Get personalized manga suggestions based on your preferences
- **Interactive Chat**: Natural language interface for discovering new content

### 📱 **Cross-Platform**
- **Mobile**: Native Android and iOS apps
- **Web**: Full web application support
- **Desktop**: macOS, Windows, and Linux support

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.x with Dart
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **API**: MyAnimeList API v2
- **AI**: Google Gemini API
- **State Management**: Flutter's built-in state management
- **UI/UX**: Custom components with Lottie animations

## 📦 Dependencies

### Core Dependencies
- `firebase_auth` - User authentication
- `cloud_firestore` - NoSQL database
- `firebase_storage` - File storage
- `http` - API communication
- `cached_network_image` - Image caching

### UI & Animation
- `lottie` - Smooth animations
- `google_fonts` - Typography
- `carousel_animations` - Image carousels
- `flutter_card_swiper` - Card swiping
- `dash_chat_2` - Chat interface

### Utilities
- `image_picker` - Photo selection
- `smooth_page_indicator` - Page indicators
- `show_up_animation` - Entrance animations

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Firebase project setup
- MyAnimeList API key
- Google Gemini API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/giovanni747/m3ngon.git
   cd m3ngon
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the respective platform directories

4. **Set up API keys**
   - Update `lib/components/const.dart` with your Gemini API key
   - MyAnimeList API key is already configured

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screenshots

### Main Features
- **Home Feed**: Discover trending manga and user posts
- **Search**: Find specific manga titles
- **Profile**: Manage your account and preferences
- **AI Chat**: Get personalized recommendations

### User Interface
- **Modern Design**: Clean, intuitive interface
- **Smooth Animations**: Lottie-powered transitions
- **Responsive Layout**: Works on all screen sizes
- **Dark/Light Themes**: Customizable appearance

## 🏗️ Project Structure

```
lib/
├── Auth/                 # Authentication logic
├── Pages/               # App screens
│   ├── componentApi/    # API-related components
│   └── intro_screens/   # Onboarding screens
├── api/                 # API service layer
├── components/          # Reusable UI components
├── helper/              # Utility functions
├── models/              # Data models
└── theme/               # App theming
```

## 🔧 Configuration

### Firebase Setup
1. Enable Authentication (Email/Password)
2. Create Firestore database
3. Set up Storage bucket
4. Configure security rules

### API Configuration
- **MyAnimeList**: Update API key in API files
- **Gemini**: Update API key in `lib/components/const.dart`

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Giovanni Sanchez**
- GitHub: [@giovanni747](https://github.com/giovanni747)

## 🙏 Acknowledgments

- [MyAnimeList](https://myanimelist.net/) for the comprehensive manga database
- [Firebase](https://firebase.google.com/) for backend services
- [Google Gemini](https://ai.google.dev/) for AI capabilities
- [Flutter](https://flutter.dev/) for the amazing framework

## 📞 Support

If you have any questions or need help, please:
- Open an issue on GitHub
- Contact the maintainer

---

⭐ **Star this repository if you found it helpful!**