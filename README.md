# Flutter GoRouter Tab Navigation with Authentication

A Flutter multi-platform application demonstrating tab-based navigation with authentication using GoRouter. This project showcases how to handle protected routes, authentication redirects, and proper back button behavior in a tabbed navigation pattern.

## Features

- ✅ **Tab Navigation**: Four-tab bottom navigation (Home, Search, News, Profile)
- ✅ **Authentication Guard**: Protected profile route with automatic login redirect
- ✅ **Smart Redirects**: Context-aware navigation after login/logout
- ✅ **Back Button Handling**: Proper back navigation that doesn't close the app
- ✅ **Multi-Platform Support**: Android, iOS, Web, Windows, macOS, Linux

## Project Structure

```
lib/
├── main.dart                    # App entry point with GoRouter configuration
├── screens/
│   ├── home_screen.dart        # Home tab screen
│   ├── search_screen.dart      # Search tab screen
│   ├── news_screen.dart        # News tab screen
│   ├── profile_screen.dart     # Profile tab screen (protected)
│   └── login_screen.dart       # Login screen with back button override
├── services/
│   └── auth_service.dart       # Simple authentication service
└── widgets/
    └── main_tab_scaffold.dart  # Bottom navigation wrapper
```

## Getting Started

### Prerequisites

- Flutter SDK ^3.8.1
- Dart SDK (included with Flutter)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/akabuli/flutter_go_router_navigation.git
   cd flutter_go_router_navigation
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

   Or run on a specific device:
   ```bash
   flutter run -d chrome        # For web
   flutter run -d windows       # For Windows
   flutter run -d <device-id>   # For specific device
   ```

## How It Works

### Navigation Flow

1. **Unauthenticated User Clicks Profile Tab**
   - User is redirected to `/login?from=profile`
   - Back button returns to home tab (doesn't close app)

2. **User Logs In**
   - Redirected to `/profile` (the originally requested page)
   - User can now access profile features

3. **User Logs Out**
   - Redirected back to `/login?from=profile`
   - Navigation stack is preserved

### Key Components

#### 1. GoRouter Configuration (`lib/main.dart`)

```dart
final GoRouter _router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isAuthenticated = AuthService.isAuthenticated;
    final isGoingToLogin = state.matchedLocation == '/login';
    final isGoingToProfile = state.matchedLocation == '/profile';

    // Redirect to login if accessing profile while not authenticated
    if (!isAuthenticated && isGoingToProfile) {
      return '/login?from=profile';
    }

    // After login, redirect to the page they came from
    if (isAuthenticated && isGoingToLogin) {
      final from = state.uri.queryParameters['from'];
      return from == 'profile' ? '/profile' : '/';
    }

    return null; // No redirect needed
  },
  // ... routes configuration
);
```

#### 2. Back Button Override (`lib/screens/login_screen.dart`)

```dart
PopScope(
  canPop: false,
  onPopInvokedWithResult: (didPop, result) {
    if (!didPop) {
      context.go('/'); // Navigate to home instead of closing app
    }
  },
  // ... login screen UI
)
```

#### 3. Shell Route for Tab Persistence

```dart
ShellRoute(
  builder: (context, state, child) {
    int currentIndex = 0;
    if (state.matchedLocation == '/search') currentIndex = 1;
    if (state.matchedLocation == '/news') currentIndex = 2;
    if (state.matchedLocation == '/profile') currentIndex = 3;

    return MainTabScaffold(currentIndex: currentIndex, child: child);
  },
  routes: [
    // Tab routes...
  ],
)
```

## Testing the Authentication Flow

1. **Launch the app** - You'll see the Home tab
2. **Tap Profile tab** - Redirects to login screen
3. **Press back button** - Returns to Home (app doesn't close)
4. **Navigate to Profile again and login** - Goes to Profile screen
5. **Tap Logout** - Returns to login screen
6. **Press back** - Returns to Home tab

## Commands Reference

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on specific platform
flutter run -d chrome
flutter run -d windows
flutter run -d android
flutter run -d ios

# Build release
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
flutter build windows      # Windows

# Run tests
flutter test

# Format code
dart format .

# Analyze code
flutter analyze
```

## Dependencies

- **[go_router](https://pub.dev/packages/go_router)** ^14.6.2 - Declarative routing for Flutter
- **[cupertino_icons](https://pub.dev/packages/cupertino_icons)** ^1.0.8 - iOS style icons

## Architecture Decisions

### Why GoRouter?

- **Declarative routing**: Define routes in one place
- **Deep linking support**: Built-in URL handling for web
- **Type-safe navigation**: Compile-time route checking
- **Redirect logic**: Easy authentication guards

### Why ShellRoute?

- **Persistent UI**: Bottom navigation stays visible across routes
- **State preservation**: Tab state is maintained during navigation
- **Better UX**: Users don't lose context when switching tabs

### Why PopScope?

- **Custom back behavior**: Override default back button action
- **Prevent app closure**: Keep users in the navigation flow
- **Better UX**: Predictable navigation patterns

## Common Issues & Solutions

### Issue: Back button closes app after login redirect
**Solution**: Use `PopScope` with `canPop: false` and custom `onPopInvokedWithResult` handler to navigate to home.

### Issue: Lost tab state after login
**Solution**: Use `ShellRoute` to wrap all tab routes, preserving the bottom navigation UI.

### Issue: Can't return to previous tab after login
**Solution**: Pass `?from=profile` parameter in redirect URL and use it after successful login.

## Contributing

Feel free to open issues or submit pull requests for improvements!

## License

This project is open source and available under the [MIT License](LICENSE).

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Flutter Navigation and Routing](https://docs.flutter.dev/development/ui/navigation)
- [Material Design 3](https://m3.material.io/)
