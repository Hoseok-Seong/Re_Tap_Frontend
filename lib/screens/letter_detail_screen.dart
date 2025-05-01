import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_letter/common/constants.dart';
import 'package:future_letter/provider/home_provider.dart';
import '../provider/letter_provider.dart';
import 'package:go_router/go_router.dart';

class LetterDetailScreen extends ConsumerWidget {
  final String letterId;
  const LetterDetailScreen({super.key, required this.letterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final letterDetail = ref.watch(letterDetailProvider(int.parse(letterId)));

    return WillPopScope(
        onWillPop: () async {
          ref.invalidate(letterListProvider);
          ref.invalidate(homeProvider);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text(
              'Read Later',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: letterDetail.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) {
              if (error is DioException) {
                final code = error.response?.data['code'];

                if (code == 'L001') {
                  Future.microtask(() {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('아직 열 수 없어요'),
                        content: const Text('설정한 도착일 이후에 열람할 수 있습니다.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      ),
                    );
                  });
                  return const SizedBox.shrink();
                }
              }

              return Center(child: Text('에러 발생: $error'));
            },
            data: (letter) {
              final isDraft = letter.status == 'DRAFT';

              if (isDraft) {
                Future.microtask(() {
                  context.push('/write', extra: letter);
                });
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      letter.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 32),
                    Text(
                      letter.content.trim().isEmpty ? '(내용 없음)' : letter.content,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              );
            },
          ),
        )
    );
  }
}
