import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../dto/letter.dart';

class LetterListScreen extends StatelessWidget {
  const LetterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final letters = [
      Letter(id: '1', title: '미래의 나에게', openDate: now.add(const Duration(days: 5)), isOpened: false),
      Letter(id: '2', title: '2024년 연말의 나', openDate: now.subtract(const Duration(days: 2)), isOpened: true),
      Letter(id: '3', title: '이번 여름의 목표', openDate: now, isOpened: true),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('내 편지함')),
      body: ListView.separated(
        itemCount: letters.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final letter = letters[index];
          final openDateStr = DateFormat('yyyy-MM-dd').format(letter.openDate);
          final isLocked = !letter.isOpened;

          return ListTile(
            leading: Icon(isLocked ? Icons.lock : Icons.mark_email_read),
            title: Text(letter.title),
            subtitle: Text("도착일: $openDateStr"),
            onTap: () {
              context.pushNamed('detail', pathParameters: {'id': letter.id});
            },
          );
        },
      ),
    );
  }
}