import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants.dart';

class ProfileAgreementScreen extends StatefulWidget {
  const ProfileAgreementScreen({super.key});

  @override
  State<ProfileAgreementScreen> createState() => _ProfileAgreementScreenState();
}

class _ProfileAgreementScreenState extends State<ProfileAgreementScreen> {
  bool agreeAll = false;
  bool agreeTerms = false;
  bool agreePrivacy = false;

  bool isExpandedTerms = false;
  bool isExpandedPrivacy = false;

  void _toggleAll(bool? value) {
    setState(() {
      agreeAll = value ?? false;
      agreeTerms = value ?? false;
      agreePrivacy = value ?? false;
    });
  }

  void _saveAgreement() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLogin', false);
    context.go('/profile-setup');  // 프로필 닉네임 설정 페이지로 이동
  }

  Widget _buildAgreementTile({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
    required String content,
    required bool isExpanded,
    required VoidCallback onExpand,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Checkbox(value: value, onChanged: onChanged),
          title: GestureDetector(
            onTap: onExpand,
            child: Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                )
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Text(content, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              '미래의 나에게 보내는\n첫 편지를 준비해볼까요?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Checkbox(value: agreeAll, onChanged: _toggleAll),
                    title: const Text('모두 동의하기', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const Divider(),
                  _buildAgreementTile(
                    title: '서비스 이용약관 (필수)',
                    value: agreeTerms,
                    onChanged: (v) {
                      setState(() {
                        agreeTerms = v ?? false;
                        agreeAll = agreeTerms && agreePrivacy;
                      });
                    },
                    content: '서비스 이용약관 내용입니다. 이 곳에 상세 약관이 들어갑니다.',
                    isExpanded: isExpandedTerms,
                    onExpand: () => setState(() => isExpandedTerms = !isExpandedTerms),
                  ),
                  _buildAgreementTile(
                    title: '개인정보 처리방침 (필수)',
                    value: agreePrivacy,
                    onChanged: (v) {
                      setState(() {
                        agreePrivacy = v ?? false;
                        agreeAll = agreeTerms && agreePrivacy;
                      });
                    },
                    content: '개인정보 처리방침 내용입니다. 이 곳에 상세 약관이 들어갑니다.',
                    isExpanded: isExpandedPrivacy,
                    onExpand: () => setState(() => isExpandedPrivacy = !isExpandedPrivacy),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: agreeTerms && agreePrivacy
                      ? AppColors.primary
                      : Colors.grey.shade300,
                ),
                onPressed: agreeTerms && agreePrivacy ? _saveAgreement : null,
                child: const Text('시작하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
