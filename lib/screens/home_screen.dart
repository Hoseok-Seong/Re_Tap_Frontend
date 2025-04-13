import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import 'main_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTodaySentence(),
            const SizedBox(height: 16),
            _buildTodayQuestion(),
            const SizedBox(height: 16),
            _buildRecentLetter(context),
            const SizedBox(height: 16),
            _buildArrivalLetter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySentence() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('오늘의 한 문장', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            '과거의 나도, 미래의 나도, 결국 지금의 내가 만든다.',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text('- FutureLetter', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTodayQuestion() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('오늘의 질문', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('오늘 하루 가장 기억에 남는 순간은 무엇인가요?', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildRecentLetter(BuildContext context) {
    bool hasLetter = false; // TODO: 서버 데이터 바인딩 시 처리

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('최근 편지', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (!hasLetter)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  context.go('/write');
                },
                child: const Text('편지 쓰러 가기'),
              ),
            )
          else
            const Text('최근 편지가 있습니다!'), // TODO: 편지 preview 넣기
        ],
      ),
    );
  }

  Widget _buildArrivalLetter() {
    int arrivalCount = 0; // TODO: 서버 데이터 바인딩 시 처리

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('도착 예정 편지', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          arrivalCount == 0
              ? const Text('아직 도착할 편지가 없어요.')
              : Row(
            children: [
              const Icon(Icons.mail, color: AppColors.primary),
              const SizedBox(width: 4),
              Text('$arrivalCount개 도착 예정!'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
