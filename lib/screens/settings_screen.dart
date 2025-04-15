import 'package:flutter/material.dart';
import 'package:future_letter/common/constants.dart';
import 'package:future_letter/common/privacy.dart';
import 'package:future_letter/common/terms.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _showTerms = false;
  bool _showPrivacy = false;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정'), backgroundColor: Colors.grey),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(  // 핵심! 스크롤 영역
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
                        onPressed: () {
                          // 로그아웃 처리
                        },
                        child: const Text('로그아웃'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          // 회원 탈퇴 처리
                        },
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
              height: 200, // 또는 MediaQuery.of(context).size.height * 0.3
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