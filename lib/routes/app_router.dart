import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/verify_code_screen.dart';
import '../screens/profile_setup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/letter_write_screen.dart';
import '../screens/letter_list_screen.dart';
import '../screens/letter_detail_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/verify',
        name: 'verify',
        builder: (context, state) => const VerifyCodeScreen(),
      ),
      GoRoute(
        path: '/setup',
        name: 'setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/write',
        name: 'write',
        builder: (context, state) => const LetterWriteScreen(),
      ),
      GoRoute(
        path: '/list',
        name: 'list',
        builder: (context, state) => const LetterListScreen(),
      ),
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return LetterDetailScreen(letterId: id!);
        },
      ),
    ],
  );
}