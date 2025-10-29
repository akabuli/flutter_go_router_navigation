# Flutter GoRouter Tab Navigation with Authentication

A Flutter multi-platform application demonstrating tab-based navigation with authentication using GoRouter. This project showcases how to handle protected routes, authentication redirects, and proper back button behavior in a tabbed navigation pattern.

## Features

- ✅ **Tab Navigation**: Four-tab bottom navigation (Home, Search, News, Profile)
- ✅ **Authentication Guard**: Protected profile route with automatic login redirect
- ✅ **Smart Redirects**: Context-aware navigation after login/logout
- ✅ **Smooth Page Transitions**: WhatsApp-style slide animations (right to left)
- ✅ **Back Button Handling**: Proper back navigation with reverse animations
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
│   └── login_screen.dart       # Login screen with slide transition
├── services/
│   └── auth_service.dart       # Simple authentication service
├── utils/
│   └── page_transitions.dart   # Reusable page transition helpers
└── widgets/
    └── main_tab_scaffold.dart  # Bottom navigation wrapper with auth check
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
   - Tab scaffold checks authentication status
   - User is navigated to `/login?from=profile` using `context.push()` (creates navigation stack)
   - Login screen slides in from right to left (WhatsApp style)

2. **User Presses Back Button**
   - `context.pop()` triggers reverse animation
   - Login screen slides out from left to right
   - Returns to the previous tab (app doesn't close)

3. **User Logs In**
   - Redirected to `/profile` (the originally requested page)
   - User can now access profile features

4. **User Logs Out**
   - Redirected back to `/login?from=profile`
   - Same slide animation applies

### Key Components

#### 1. Custom Page Transitions (`lib/utils/page_transitions.dart`)

```dart
/// Creates a slide transition from right to left (like WhatsApp)
CustomTransitionPage slideFromRightTransition({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Start from right
      const end = Offset.zero; // End at center
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
```

**How it works:**
- `Offset(1.0, 0.0)` = Start position (right side of screen)
- `Offset.zero` = End position (center)
- `context.pop()` automatically uses the reverse animation (left to right)

#### 2. GoRouter Configuration (`lib/main.dart`)

```dart
final GoRouter _router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isAuthenticated = AuthService.isAuthenticated;
    final isGoingToLogin = state.matchedLocation == '/login';
    final isGoingToProfile = state.matchedLocation == '/profile';

    // Redirect to home if accessing profile directly without auth (deep link)
    if (!isAuthenticated && isGoingToProfile) {
      return '/';
    }

    // After login, redirect to the page they came from
    if (isAuthenticated && isGoingToLogin) {
      final from = state.uri.queryParameters['from'];
      return from == 'profile' ? '/profile' : '/';
    }

    return null; // No redirect needed
  },
  routes: [
    // ... tab routes in ShellRoute
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return slideFromRightTransition(
          key: state.pageKey,
          child: const LoginScreen(),
        );
      },
    ),
  ],
);
```

#### 3. Tab Scaffold with Authentication Check (`lib/widgets/main_tab_scaffold.dart`)

```dart
void _onTabTapped(int index) {
  // Check if trying to access profile without authentication
  if (index == 3 && !AuthService.isAuthenticated) {
    // Use push() to create navigation stack for proper animation
    context.push('/login?from=profile');
    return;
  }

  // Navigate to other tabs normally
  switch (index) {
    case 0: context.go('/'); break;
    case 1: context.go('/search'); break;
    case 2: context.go('/news'); break;
    case 3: context.go('/profile'); break;
  }
}
```

**Key difference:**
- `context.push()` = Creates navigation stack → `context.pop()` works with animation ✅
- `context.go()` = Replaces route → No stack to pop → No reverse animation ❌

#### 4. Login Screen with Proper Back Navigation (`lib/screens/login_screen.dart`)

```dart
PopScope(
  canPop: true, // Allow default pop behavior
  child: Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (context.canPop()) {
            context.pop(); // Triggers reverse slide animation
          } else {
            context.go('/'); // Fallback
          }
        },
      ),
      // ... rest of AppBar
    ),
    // ... body
  ),
)
```

## Testing the Authentication Flow

1. **Launch the app** - You'll see the Home tab
2. **Tap Profile tab** - Login screen slides in from right to left
3. **Press back button (AppBar or system)** - Login screen slides out from left to right, returns to Home
4. **Navigate to Profile again and tap Login** - Redirects to Profile screen (no animation, instant)
5. **Tap Logout** - Returns to login screen with slide animation
6. **Press back** - Slides back to Home tab

**Animations:**
- ✅ Opening login: Slides **right → left** (WhatsApp style)
- ✅ Back from login: Slides **left → right** (reverse animation)
- ⚡ After login redirect: Instant (no animation)

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
- **Custom transitions**: Full control over page animations

### Why ShellRoute?

- **Persistent UI**: Bottom navigation stays visible across routes
- **State preservation**: Tab state is maintained during navigation
- **Better UX**: Users don't lose context when switching tabs

### Why Custom Transitions?

- **Better UX**: Smooth, predictable animations like WhatsApp
- **Visual feedback**: Users see where they came from and where they're going
- **Professional feel**: Polished navigation experience

### Why context.push() vs context.go()?

- **`context.push('/route')`**: Creates navigation stack entry
  - ✅ Allows `context.pop()` to work
  - ✅ Enables reverse animations
  - ✅ Better for modal-style navigation (login, details, etc.)

- **`context.go('/route')`**: Replaces current route
  - ✅ Good for tab switching (no stack buildup)
  - ❌ No back stack
  - ❌ No reverse animations

**Rule of thumb**: Use `push()` for pages you want users to back out of with animation. Use `go()` for lateral navigation (tabs, main sections).

## Common Issues & Solutions

### Issue: Back button closes app after login redirect

**Solution**: Use `context.push()` instead of `context.go()` or redirect when navigating to login. This creates a proper navigation stack entry that can be popped with animation.

### Issue: Lost tab state after login

**Solution**: Use `ShellRoute` to wrap all tab routes, preserving the bottom navigation UI.

### Issue: Can't return to previous tab after login

**Solution**: Pass `?from=profile` parameter in redirect URL and use it after successful login.

### Issue: No animation on back button

**Solution**: Ensure you're using `context.push()` to navigate TO the login screen, then `context.pop()` to go back. Using `context.go()` for both directions won't create a navigation stack and won't animate.

### Issue: Login screen slides in but doesn't slide out

**Solution**: Check that `PopScope.canPop` is set to `true` and the back button uses `context.pop()` instead of `context.go('/')`.

## Page Transition Options

You can customize transitions by modifying `lib/utils/page_transitions.dart`:

| Transition Type | Begin Offset | Description |
|----------------|--------------|-------------|
| **Right to Left** (WhatsApp) | `Offset(1.0, 0.0)` | Slides from right (default) |
| **Left to Right** | `Offset(-1.0, 0.0)` | Slides from left |
| **Bottom to Top** | `Offset(0.0, 1.0)` | Slides from bottom (modal style) |
| **Top to Bottom** | `Offset(0.0, -1.0)` | Slides from top |
| **Fade** | N/A | Fade in/out |

**Example - Change to bottom-to-top transition:**

```dart
// In lib/main.dart
GoRoute(
  path: '/login',
  pageBuilder: (context, state) {
    return slideFromBottomTransition( // Changed from slideFromRightTransition
      key: state.pageKey,
      child: const LoginScreen(),
    );
  },
),
```

## Contributing

Feel free to open issues or submit pull requests for improvements!

## License

This project is open source and available under the [MIT License](LICENSE).

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Flutter Navigation and Routing](https://docs.flutter.dev/development/ui/navigation)
- [Material Design 3](https://m3.material.io/)
