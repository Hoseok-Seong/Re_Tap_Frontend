import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../dto/mypage/my_page_resp.dart';
import '../provider/my_page_provider.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  bool _showDescription = false;

  @override
  Widget build(BuildContext context) {
    final myPageAsync = ref.watch(myPageProvider);

    return myPageAsync.when(
      data: (myPage) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(context, myPage),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('마이페이지 데이터를 불러오지 못했어요')),
          );
        });

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileCard(context, MyPageResp(id: 0, username: '', provider: '', nickname: '', role: '', profileImageUrl: '')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(BuildContext context, MyPageResp resp) {
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
                children: [
                  if (resp.nickname != null && resp.nickname!.isNotEmpty)
                    Text(
                      resp.nickname!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  if (resp.username != null && resp.username!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        resp.username!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  if ((resp.nickname == null || resp.nickname!.isEmpty) &&
                      (resp.username == null || resp.username!.isEmpty))
                    const Text(
                      '정보 없음',
                      style: TextStyle(color: Colors.grey),
                    ),
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
                'ReTap은 당신의 목표를 작성하는 앱입니다.\n\n제목은 간결하게, 내용은 최대한 구체적으로 작성해주세요.\n\n설정한 알림일자에 나의 목표를 알림으로 받을 수 있어요.\n\n내가 얼마나 목표를 잘 달성했는지, 달성도를 평가하고 스스로에게 피드백을 줄 수 있어요.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            crossFadeState: _showDescription ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),

          const SizedBox(height: 32),

          // 버전 정보
          Row(
            children: const [
              Icon(Icons.verified_user_outlined, color: Colors.black),
              SizedBox(width: 8),
              Text('버전 정보', style: TextStyle(fontSize: 16)),
              Spacer(),
              Text('v1.0.0', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
