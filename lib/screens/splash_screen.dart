import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/constants.dart';
import '../token/token_storage.dart';
import '../provider/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 2)); // 로딩 연출

    final access = await TokenStorage.getAccessToken();
    final refresh = await TokenStorage.getRefreshToken();

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      ref.read(authStateProvider.notifier).state = AuthState.loggedOut;
      context.go('/onboarding');
    } else if (access != null && refresh != null) {
      ref.read(authStateProvider.notifier).state = AuthState.loggedIn;
      context.go('/home');
    } else {
      ref.read(authStateProvider.notifier).state = AuthState.loggedOut;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Text(
          'ReTap',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
