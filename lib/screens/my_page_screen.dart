import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import 'main_layout.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  bool _showDescription = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildProfileCard(context),
          ],
        ),
      );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('마이페이지', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  context.push('/settings');
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 프로필
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFF4F4F4),
                child: Text(
                  '🙂',
                  style: TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('사용자 닉네임', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text('example@email.com', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 서비스 소개 토글
          GestureDetector(
            onTap: () {
              setState(() {
                _showDescription = !_showDescription;
              });
            },
            child: Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: 8),
                const Text('서비스 소개', style: TextStyle(fontSize: 16)),
                const Spacer(),
                Icon(_showDescription ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'Read Later은 미래의 나에게 편지를 쓰는 앱입니다.\n\n고민, 목표, 응원 등을 기록해 보세요.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            crossFadeState: _showDescription ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),

          const SizedBox(height: 32),

          // 버전 정보
          Row(
            children: [
              const Icon(Icons.verified_user_outlined, color: Colors.black),
              const SizedBox(width: 8),
              const Text('버전 정보', style: TextStyle(fontSize: 16)),
              const Spacer(),
              const Text('v1.0.0', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
