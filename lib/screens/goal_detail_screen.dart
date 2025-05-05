import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import '../provider/goal_provider.dart';
import '../provider/home_provider.dart';

class GoalDetailScreen extends ConsumerWidget {
  final String goalId;
  const GoalDetailScreen({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalDetail = ref.watch(goalDetailProvider(int.parse(goalId)));

    return WillPopScope(
        onWillPop: () async {
          ref.invalidate(goalListProvider);
          ref.invalidate(homeProvider);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text(
              'ReTap',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: goalDetail.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) {
              if (error is DioException) {
                final code = error.response?.data['code'];

                if (code == 'G001') {
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
            data: (goal) {
              final isDraft = goal.status == 'DRAFT';

              if (isDraft) {
                Future.microtask(() {
                  context.push('/write', extra: goal);
                });
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 32),
                    Text(
                      goal.content.trim().isEmpty ? '(내용 없음)' : goal.content,
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
