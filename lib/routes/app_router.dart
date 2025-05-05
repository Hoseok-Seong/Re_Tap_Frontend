import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../dto/auth/oauth_check_req.dart';
import '../dto/goal/goal_list_resp.dart';
import '../layout/main_layout.dart';
import '../provider/auth_provider.dart';
import '../screens/agreement_screen.dart';
import '../screens/goal_detail_screen.dart';
import '../screens/on_boarding_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/welcome_screen.dart';

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
          pageBuilder: (context, state) {
            final extra = state.extra as OauthCheckReq;
            return MaterialPage(
              child: AgreementScreen(oauthInfo: extra),
            );
          },
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
          pageBuilder: (context, state) => NoTransitionPage(
            child: MainLayout(currentIndex: 1, goal: state.extra as GoalSummary?),
          ),
        ),
        GoRoute(
          path: '/goals',
          name: 'goals',
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
            return GoalDetailScreen(goalId: id!);
          },
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/welcome',
          name: 'welcome',
          builder: (context, state) => WelcomeScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/main',
          name: 'main',
          pageBuilder: (context, state) {
            final tabParam = state.uri.queryParameters['tab'];
            final tabIndex = int.tryParse(tabParam ?? '0') ?? 0;

            return NoTransitionPage(
              child: MainLayout(currentIndex: tabIndex, goal: state.extra as GoalSummary?),
            );
          },
        ),
      ],
      redirect: (context, state) {
        final container = ProviderScope.containerOf(context, listen: false);
        final authState = container.read(authStateProvider);

        final path = state.uri.path;
        final isPublicPath = path == '/login' || path == '/' || path == '/agreement'
            || path == '/onboarding' || path == '/welcome';

        if (authState == AuthState.loggedOut && !isPublicPath) {
          return '/login';
        }

        if (authState == AuthState.loggedIn && path == '/login') {
          return '/home';
        }

        return null;
      }
  );
}