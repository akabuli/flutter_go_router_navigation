import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'services/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/news_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'widgets/main_tab_scaffold.dart';
import 'utils/page_transitions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = AuthService.isAuthenticated;
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToProfile = state.matchedLocation == '/profile';

      // If not authenticated and trying to access profile directly (e.g., deep link)
      // redirect to home instead
      if (!isAuthenticated && isGoingToProfile) {
        return '/';
      }

      // If authenticated and on login page, redirect based on 'from' parameter
      if (isAuthenticated && isGoingToLogin) {
        final from = state.uri.queryParameters['from'];
        return from == 'profile' ? '/profile' : '/';
      }

      return null; // No redirect needed
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          int currentIndex = 0;
          if (state.matchedLocation == '/search') currentIndex = 1;
          if (state.matchedLocation == '/news') currentIndex = 2;
          if (state.matchedLocation == '/profile') currentIndex = 3;

          return MainTabScaffold(currentIndex: currentIndex, child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/news',
            builder: (context, state) => const NewsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Tab Navigation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
