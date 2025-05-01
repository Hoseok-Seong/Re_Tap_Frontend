import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import '../provider/auth_provider.dart';
import '../provider/user_provider.dart';
import '../service/auth_service.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  WelcomeScreen({super.key});

  final authService = AuthService();

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  final TextEditingController _nicknameController = TextEditingController();

  bool get _isNicknameFilled => _nicknameController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _submitNickname() async {
    final nickname = _nicknameController.text.trim();

    try {
      await ref.read(updateNicknameProvider(nickname).future);
      ref.read(authStateProvider.notifier).state = AuthState.loggedIn;
      context.go('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('닉네임 저장에 실패했어요: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true, // 키보드 올라와도 UI 줄어들도록
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      const Icon(Icons.mail_outline,
                          size: 80, color: AppColors.primary),
                      const SizedBox(height: 16),
                      Text(
                        '환영합니다!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '미래의 나에게, 첫 편지를 남겨보세요.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _nicknameController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: '닉네임을 입력하세요',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isNicknameFilled
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                          onPressed: _isNicknameFilled ? _submitNickname : null,
                          child: const Text('시작하기'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}