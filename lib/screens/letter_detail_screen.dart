import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/letter.dart';

class LetterDetailScreen extends StatelessWidget {
  final String letterId;
  const LetterDetailScreen({super.key, required this.letterId});

  // 테스트용 mock 데이터
  Letter getMockLetter(String id) {
    final now = DateTime.now();

    if (id == '1') {
      return Letter(
        id: '1',
        title: '미래의 나에게',
        openDate: now.add(const Duration(days: 5)),
        isOpened: false,
      );
    } else {
      return Letter(
        id: id,
        title: '2024년의 나',
        openDate: now.subtract(const Duration(days: 1)),
        isOpened: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final letter = getMockLetter(letterId);
    final isLocked = !letter.isOpened;
    final dateStr = DateFormat('yyyy-MM-dd').format(letter.openDate);

    return Scaffold(
      appBar: AppBar(title: const Text('편지 보기')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: isLocked
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              "이 편지는 아직 열 수 없어요.\n열람 가능일: $dateStr",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              letter.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32),
            const Text(
              "안녕, 이건 너에게 쓰는 편지야...\n\n(편지 본문은 추후 API 연동)",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}