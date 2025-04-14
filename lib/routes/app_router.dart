import 'package:future_letter/screens/my_page_screen.dart';
import 'package:future_letter/screens/notification_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
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
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        name: 'profile-setup',
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
        path: '/letters',
        name: 'letters',
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
      GoRoute(
        path: '/mypage',
        name: 'mypage',
        builder: (context, state) => const MyPageScreen(),
      ),
      GoRoute(
        path: '/notification',
        name: 'notification',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}