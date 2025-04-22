import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../common/constants.dart';
import '../dto/letter/letter.dart';
import 'main_layout.dart';

class LetterListScreen extends StatelessWidget {
  const LetterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final letters = [
      Letter(id: '1', title: '미래의 나에게', content: '', openDate: now.add(const Duration(days: 5)), isOpened: false, status: 'sent'),
      Letter(id: '2', title: '2024년 연말의 나', content: '', openDate: now.subtract(const Duration(days: 2)), isOpened: true, status: 'arrived'),
      Letter(id: '3', title: '이번 여름의 목표', content: '', openDate: now, isOpened: true, status: 'saved'),  // 임시저장
    ];

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: letters.isEmpty
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('아직 작성한 편지가 없어요 😢',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.go('/write');
                    },
                    child: const Text(
                      '편지 쓰러 가기 →',
                      style: TextStyle(fontSize: 16, color: AppColors.primary),
                    ),
                  )
                ],
              ),
            )
            : ListView.separated(
                itemCount: letters.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final letter = letters[index];
                  final openDateStr =
                  DateFormat('yyyy-MM-dd').format(letter.openDate);

                  IconData icon;
                  Color iconColor = AppColors.primary;

                  switch (letter.status) {
                    case 'saved':
                      icon = Icons.edit;
                      iconColor = Colors.blue;
                      break;
                    case 'sent':
                      icon = letter.isOpened
                          ? Icons.mark_email_read
                          : Icons.lock;
                      iconColor =
                      letter.isOpened ? AppColors.primary : Colors.grey;
                      break;
                    default:
                      icon = Icons.mark_email_read;
                  }

                  return GestureDetector(
                    onTap: () {
                      context.pushNamed('detail',
                          pathParameters: {'id': letter.id});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: iconColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  letter.title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "도착일: $openDateStr",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
        ),
      );
  }
}
