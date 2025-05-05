import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState {
  loggedIn,
  loggedOut,
}

final authStateProvider = StateProvider<AuthState>((ref) => AuthState.loggedIn);
