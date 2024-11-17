# GreenScope 🌿

GreenScope is an innovative iOS application that empowers users to make sustainable choices through AI-powered product analysis and community engagement. Using OpenAI's Vision API and Firebase services, the app provides detailed sustainability insights and connects eco-conscious individuals.

## Project Structure 📁

```
GreenScope/
├── Config/
│   ├── Config.swift
│   └── Config.template.swift
├── GreenScopeTests/
├── GreenScopeUITests/
│   └── GreenScopeUITestsLaunchTests
├── Products/
│   ├── GreenScope
│   ├── GreenScopeTests
│   └── GreenScopeUITests
├── GreenScope/
│   ├── Component/
│   │   ├── HomeComponents
│   │   ├── ButtonStyle
│   │   ├── Color
│   │   ├── HeroBannerView
│   │   ├── Leaf
│   │   ├── QuickActionCard
│   │   ├── SharedComponents
│   │   ├── TextField
│   │   ├── TipCard
│   │   └── TipsSection
│   ├── Extensions/
│   │   └── Color+Hex
│   ├── Models/
│   │   ├── AuthenticationViewModel
│   │   ├── ChatMessage
│   │   ├── NotificationModel
│   │   ├── Product
│   │   ├── SustainabilityScore
│   │   └── UserProfile
│   ├── Preview Content/
│   │   └── Preview Assets
│   ├── Services/
│   │   ├── AuthenticationService
│   │   ├── ChatService
│   │   ├── LocationService
│   │   ├── NotificationService
│   │   ├── OpenAIService
│   │   └── ProductService
│   ├── Utilities/
│   │   ├── Constants
│   │   └── Extensions
│   ├── ViewModels/
│   │   ├── ProductViewModel
│   │   ├── ProfileViewModel
│   │   └── ScanViewModel
│   └── Views/
│       ├── AlternativesView
│       ├── AIChatView
│       ├── AuthenticationView
│       ├── CommunityChatView
│       ├── CoreDataTestView
│       ├── FAQView
│       ├── HomeView
│       ├── NearbyEcoView
│       ├── NotificationsView
│       ├── ProductDetailView
│       ├── ProfileView
│       ├── ResetPasswordView
│       ├── ScanView
│       ├── SettingsRelatedViews
│       ├── SettingsView
│       ├── SignUpView
│       ├── SplashScreen
│       └── SustainabilityView
└── Package Dependencies/
    ├── abseil (1.202401602.0)
    ├── AppCheck (11.2.0)
    ├── Firebase (11.5.0)
    ├── GoogleAppMeasurement (11.4.0)
    ├── GoogleDataTransport (10.1.0)
    ├── GoogleUtilities (8.0.2)
    ├── gRPC (1.65.1)
    ├── GTMSessionFetcher (4.1.0)
    ├── InteropForGoogle (100.0.0)
    ├── leveldb (1.22.5)
    ├── nanopb (2.30910.0)
    ├── Promises (2.4.0)
    └── SwiftProtobuf (1.28.2)
```

## Features 🚀

### Core Features
- **AI-Powered Product Analysis** 📸
  - Barcode scanning for instant product information
  - Image recognition using OpenAI Vision API
  - Detailed sustainability scoring and analysis

- **Authentication & User Profiles** 👤
  - Firebase authentication system
  - Customizable user profiles
  - Password reset functionality
  - Secure sign-up process

- **Community Features** 💭
  - AI Chat integration
  - Community chat rooms
  - Nearby eco-friendly locations
  - FAQ system

- **Product Management** 🏷
  - Detailed product information
  - Sustainability scoring
  - Alternative product suggestions
  - Scan functionality

### Technical Stack 🛠

- **Frontend**
  - SwiftUI for modern UI components
  - Custom components for reusability
  - Responsive design system

- **Backend Services**
  - Firebase (v11.5.0)
  - OpenAI Integration
  - Location Services
  - Push Notifications

- **Key Dependencies**
  - Firebase Suite
  - OpenAI Integration (abseil)
  - Google Services
  - Data Transport & Storage


## Prerequisites 📋

- Xcode 15.0+
- iOS 15.0+
- Swift 5.0+
- CocoaPods or Swift Package Manager
- Active Apple Developer Account
- OpenAI API Key
- Firebase Account

## Installation 💻

1. **Clone the Repository**
```bash
git clone https://github.com/vhicktour/GreenScope.git
cd GreenScope
```

2. **Configure Environment**
```bash
# Create configuration file from template
cp Config.template.swift Config.swift

# Edit Config.swift with your API keys
nano Config.swift
```

3. **Install Dependencies**
```bash
# Using Swift Package Manager
xcode-select --install
# Dependencies will automatically resolve when opening Xcode project
```

4. **Firebase Setup**
- Download `GoogleService-Info.plist` from Firebase Console
- Add to project root
- Don't commit this file (already in .gitignore)

5. **Configure OpenAI**
- Add your OpenAI API key to Config.swift
```swift
static let openAIKey = "your-api-key-here"
```

6. **Build and Run**
- Open `GreenScope.xcodeproj`
- Select your development team
- Choose your target device/simulator
- Build and run (⌘R)



## Configuration ⚙️

### Required Keys
1. OpenAI API Key
2. Firebase Configuration
3. Google Services

Add to `Config.swift`:
```swift
struct APIConfig {
    static let openAIKey = "your-openai-key"
    static let firebaseConfig = "your-firebase-config"
    // Add other keys
}
```

## Development 👨‍💻

1. **Create New Feature Branch**
```bash
git checkout -b feature/your-feature-name
```

2. **Make Changes and Test**
```bash
# Run tests
Command + U

# Build and run
Command + R
```

3. **Commit Changes**
```bash
git add .
git commit -m "Description of changes"
git push origin feature/your-feature-name
```

## Troubleshooting 🔧

Common issues and solutions:

1. **Build Errors**
```bash
# Clean build folder
Command + Shift + K

# Clean build cache
Command + Option + Shift + K
```

2. **Dependencies Issues**
```bash
# Reset package cache
File > Packages > Reset Package Cache
```

3. **Firebase Configuration**
- Ensure `GoogleService-Info.plist` is properly added
- Check Bundle ID matches Firebase configuration

## Contributing 🤝

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## Security 🔒

- Never commit API keys
- Keep `Config.swift` in .gitignore
- Use secure Firebase rules
- Follow Apple's security guidelines

## License 📝

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Credits 👏

Created by Victor Udeh & Shedrack Udeh

## Contact 📫

Victor Udeh - [@vhicktour](https://github.com/vhicktour)

Project Link: [https://github.com/vhicktour/GreenScope](https://github.com/vhicktour/GreenScope)

---

**Note**: Ensure you have all necessary Apple developer certificates and provisioning profiles set up for building and running the app on physical devices.
