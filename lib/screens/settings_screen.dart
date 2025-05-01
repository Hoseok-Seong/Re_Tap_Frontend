import 'package:flutter/material.dart';
import 'package:future_letter/common/constants.dart';
import 'package:future_letter/common/privacy.dart';
import 'package:future_letter/common/terms.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/auth_provider.dart';
import '../provider/user_provider.dart';
import '../token/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _showTerms = false;
  bool _showPrivacy = false;

  Future<void> _confirmWithdraw() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "정말 회원 탈퇴하시겠어요?",
          style: TextStyle(fontSize: 20),
        ),
        content: const Text(
          "탈퇴 시 모든 편지, 프로필 정보가 완전히 삭제되며 복구가 불가능합니다.\n\n정말 탈퇴하시겠습니까?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("취소"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("탈퇴하기"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // 실제 탈퇴 API 호출
    final result = await ref.read(withDrawProvider.future);
    if (mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(result.message), // "회원 탈퇴가 완료되었습니다."
          actions: [
            TextButton(
              onPressed: () async {
                // 1. 다이얼로그 먼저 닫기 (뒤에 context.push 등 호출 충돌 방지)
                Navigator.pop(context);

                // 2. SharedPreferences 값 먼저 저장
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('hasShownGuide', false);
                await prefs.setBool('isFirstLaunch', true);

                // 3. 토큰 제거
                await TokenStorage.clear();

                // 4. 상태 초기화
                ref.read(authStateProvider.notifier).state = AuthState.loggedOut;

                // 5. 화면 이동 (상태 바뀌었을 경우 자동 리디렉션이 되면 생략도 가능)
                if (mounted) {
                  context.go('/');
                }
              },
              child: const Text("확인"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정'), backgroundColor: Colors.grey),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAccordion(
                      title: '서비스 이용약관',
                      isExpanded: _showTerms,
                      onTap: () => setState(() => _showTerms = !_showTerms),
                      content: termsOfService,
                    ),
                    const SizedBox(height: 16),
                    _buildAccordion(
                      title: '개인정보 처리방침',
                      isExpanded: _showPrivacy,
                      onTap: () => setState(() => _showPrivacy = !_showPrivacy),
                      content: privacyPolicy,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          await TokenStorage.clear();
                          ref.read(authStateProvider.notifier).state = AuthState.loggedOut;
                          context.go('/login');
                        },
                        child: const Text('로그아웃'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _confirmWithdraw,
                        child: const Text(
                          '회원 탈퇴',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordion({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const Spacer(),
              Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 200,
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
      ],
    );
  }
}