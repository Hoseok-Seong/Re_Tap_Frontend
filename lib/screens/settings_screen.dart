import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('서비스 소개'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title: const Text('이용약관 및 개인정보 처리방침'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined),
            title: const Text('버전 정보'),
            trailing: const Text('v1.0.0', style: TextStyle(color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('로그아웃'),
            onTap: () {},
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton(
              onPressed: () {},
              child: const Text('회원 탈퇴', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}