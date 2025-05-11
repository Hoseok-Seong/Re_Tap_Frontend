import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import '../dto/goal/goal_feedback_req.dart';
import '../provider/goal_provider.dart';
import '../provider/home_provider.dart';

class GoalDetailScreen extends ConsumerStatefulWidget {
  final String goalId;
  const GoalDetailScreen({super.key, required this.goalId});

  @override
  ConsumerState<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends ConsumerState<GoalDetailScreen> {
  double rating = 0.0;
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final goalDetail = ref.watch(goalDetailProvider(int.parse(widget.goalId)));

    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(goalListProvider);
        ref.invalidate(homeProvider);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            'ReTap',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            return Center(child: Text('목표 데이터를 받아오지 못했습니다. 다시 시도해주세요.'));
          },
          data: (goal) {
            final isDraft = goal.status == 'DRAFT';
            final isEditable = goal.score == null || goal.feedback == null;

            if (!isEditable) {
              feedbackController.text = goal.feedback ?? '';
              rating = goal.score?.toDouble() ?? 0;
            }

            if (isDraft) {
              Future.microtask(() {
                context.push('/write', extra: goal);
              });
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                // 제목
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      goal.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const Divider(height: 0),

                // 본문 내용 (스크롤 가능)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        goal.content.trim().isEmpty ? '(내용 없음)' : goal.content,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),

                // 피드백 입력 영역
                if (!goal.isLocked && goal.score == null && (goal.arrivalDate == null || goal.arrivalDate!.isBefore(DateTime.now())))
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 별점 라벨 + 별점 위젯
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '이 목표, 얼마나 달성하셨나요?',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              isEditable
                                  ? RatingBar.builder(
                                initialRating: rating,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding: EdgeInsets.zero,
                                itemSize: 20,
                                itemBuilder: (context, _) => const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Icon(Icons.star, color: Colors.amber),
                                ),
                                onRatingUpdate: (value) {
                                  setState(() {
                                    rating = value;
                                  });
                                },
                              )
                                  : RatingBarIndicator(
                                rating: goal.score?.toDouble() ?? 0,
                                itemCount: 5,
                                itemSize: 20,
                                itemBuilder: (context, _) =>
                                const Icon(Icons.star, color: Colors.amber),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 피드백 텍스트 필드
                          TextField(
                            controller: feedbackController,
                            readOnly: !isEditable,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: '목표에 대해 스스로에게 피드백을 남겨보세요',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 저장 버튼 (입력 가능할 때만)
                          if (isEditable)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  final feedbackText = feedbackController.text.trim();
                                  final scoreInt = rating.toInt();

                                  if (scoreInt < 1 || feedbackText.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('별점과 피드백을 모두 입력해주세요.')),
                                    );
                                    return;
                                  }

                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('피드백은 한 번 저장하면 수정할 수 없어요'),
                                      content: const Text('피드백을 저장할까요?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('취소'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('저장하기'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm != true) return;

                                  final req = GoalFeedbackReq(
                                    goalId: goal.goalId,
                                    score: scoreInt,
                                    feedback: feedbackText,
                                  );

                                  try {
                                    await ref.read(feedbackGoalProvider(req).future);
                                    feedbackController.clear();
                                    setState(() => rating = 0.0);
                                    ref.invalidate(goalDetailProvider(goal.goalId));
                                    FocusScope.of(context).unfocus();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('피드백이 저장되었어요!')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('피드백 저장에 실패했어요. 다시 시도해주세요.')),
                                    );
                                  }
                                },
                                child: const Text('피드백 저장'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

