import 'package:future_letter/screens/agreement_screen.dart';
import 'package:future_letter/screens/my_page_screen.dart';
import 'package:future_letter/screens/notification_screen.dart';
import 'package:future_letter/screens/welcome_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/main_layout.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
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
        path: '/agreement',
        name: 'agreement',
        builder: (context, state) => const AgreementScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MainLayout(currentIndex: 0),
        ),
      ),
      GoRoute(
        path: '/write',
        name: 'write',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MainLayout(currentIndex: 1),
        ),
      ),
      GoRoute(
        path: '/letters',
        name: 'letters',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MainLayout(currentIndex: 2),
        ),
      ),
      GoRoute(
        path: '/mypage',
        name: 'mypage',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MainLayout(currentIndex: 3),
        ),
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
        path: '/notification',
        name: 'notification',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
    ],
  );
}