import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // Allow default pop behavior
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Use pop() which will trigger the reverse slide animation
              if (context.canPop()) {
                context.pop();
              } else {
                // Fallback if somehow can't pop
                context.go('/');
              }
            },
          ),
          title: const Text('Login'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please login to access your profile',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  AuthService.login();
                  final from = GoRouterState.of(
                    context,
                  ).uri.queryParameters['from'];
                  if (from == 'profile') {
                    context.go('/profile');
                  } else {
                    context.go('/');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
