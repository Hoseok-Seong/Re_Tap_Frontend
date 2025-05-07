// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
//
// import '../common/constants.dart';
// import '../provider/goal_provider.dart';
// import '../provider/home_provider.dart';
//
// class GoalDetailScreen extends ConsumerWidget {
//   final String goalId;
//   const GoalDetailScreen({super.key, required this.goalId});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final goalDetail = ref.watch(goalDetailProvider(int.parse(goalId)));
//
//     double rating = 0.0;
//     final feedbackController = TextEditingController();
//
//     return WillPopScope(
//         onWillPop: () async {
//           ref.invalidate(goalListProvider);
//           ref.invalidate(homeProvider);
//           return true;
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: AppColors.primary,
//             title: const Text(
//               'ReTap',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           body: goalDetail.when(
//             loading: () => const Center(child: CircularProgressIndicator()),
//             error: (error, stack) {
//               if (error is DioException) {
//                 final code = error.response?.data['code'];
//
//                 if (code == 'G001') {
//                   Future.microtask(() {
//                     showDialog(
//                       context: context,
//                       builder: (_) => AlertDialog(
//                         title: const Text('아직 열 수 없어요'),
//                         content: const Text('설정한 도착일 이후에 열람할 수 있습니다.'),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               Navigator.pop(context);
//                             },
//                             child: const Text('확인'),
//                           ),
//                         ],
//                       ),
//                     );
//                   });
//                   return const SizedBox.shrink();
//                 }
//               }
//
//               return Center(child: Text('에러 발생: $error'));
//             },
//             data: (goal) {
//               final isDraft = goal.status == 'DRAFT';
//
//               if (isDraft) {
//                 Future.microtask(() {
//                   context.push('/write', extra: goal);
//                 });
//                 return const SizedBox.shrink();
//               }
//
//               return Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       goal.title,
//                       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     const Divider(height: 32),
//                     Text(
//                       goal.content.trim().isEmpty ? '(내용 없음)' : goal.content,
//                       style: const TextStyle(fontSize: 16, height: 1.5),
//                     ),
//                   const SizedBox(height: 40),
//
//                     if (goal.status != 'DRAFT') ...[
//                       const Text('이 목표, 얼마나 달성하셨나요?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 16),
//
//                       // ⭐ 별점 위젯
//                       RatingBar.builder(
//                         initialRating: 0,
//                         minRating: 1,
//                         direction: Axis.horizontal,
//                         allowHalfRating: false,
//                         itemCount: 5,
//                         itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//                         itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
//                         onRatingUpdate: (value) {
//                           rating = value;
//                         },
//                       ),
//                       const SizedBox(height: 24),
//
//                       // 📝 피드백 입력창
//                       TextField(
//                         controller: feedbackController,
//                         maxLines: 4,
//                         decoration: const InputDecoration(
//                           hintText: '목표에 대해 스스로에게 피드백을 남겨보세요',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//
//                       // 📤 제출 버튼
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             // 예시: 서버로 전송
//                             // try {
//                             //   await ref.read(goalServiceProvider).submitFeedback(
//                             //     goalId: goal.goalId,
//                             //     score: rating.toInt(),
//                             //     feedback: feedbackController.text.trim(),
//                             //   );
//                             //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('피드백이 저장되었어요!')));
//                             // } catch (e) {
//                             //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('오류 발생: $e')));
//                             // }
//                           },
//                           child: const Text('피드백 저장'),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               );
//             },
//           ),
//         )
//     );
//   }
// }



// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
//
// import '../common/constants.dart';
// import '../provider/goal_provider.dart';
// import '../provider/home_provider.dart';
//
// class GoalDetailScreen extends ConsumerStatefulWidget {
//   final String goalId;
//   const GoalDetailScreen({super.key, required this.goalId});
//
//   @override
//   ConsumerState<GoalDetailScreen> createState() => _GoalDetailScreenState();
// }
//
// class _GoalDetailScreenState extends ConsumerState<GoalDetailScreen> {
//   double rating = 0.0;
//   final TextEditingController feedbackController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     final goalDetail = ref.watch(goalDetailProvider(int.parse(widget.goalId)));
//
//     return WillPopScope(
//       onWillPop: () async {
//         ref.invalidate(goalListProvider);
//         ref.invalidate(homeProvider);
//         return true;
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         appBar: AppBar(
//           backgroundColor: AppColors.primary,
//           title: const Text(
//             'ReTap',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: goalDetail.when(
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (error, stack) {
//             if (error is DioException) {
//               final code = error.response?.data['code'];
//               if (code == 'G001') {
//                 Future.microtask(() {
//                   showDialog(
//                     context: context,
//                     builder: (_) => AlertDialog(
//                       title: const Text('아직 열 수 없어요'),
//                       content: const Text('설정한 도착일 이후에 열람할 수 있습니다.'),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                             Navigator.pop(context);
//                           },
//                           child: const Text('확인'),
//                         ),
//                       ],
//                     ),
//                   );
//                 });
//                 return const SizedBox.shrink();
//               }
//             }
//             return Center(child: Text('에러 발생: $error'));
//           },
//           data: (goal) {
//             final isDraft = goal.status == 'DRAFT';
//
//             if (isDraft) {
//               Future.microtask(() {
//                 context.push('/write', extra: goal);
//               });
//               return const SizedBox.shrink();
//             }
//
//             return Column(
//               children: [
//                 // 상단: 스크롤 가능한 내용
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           goal.title,
//                           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         const Divider(height: 32),
//                         Text(
//                           goal.content.trim().isEmpty ? '(내용 없음)' : goal.content,
//                           style: const TextStyle(fontSize: 16, height: 1.5),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 // 하단: 피드백 UI
//                 if (!isDraft)
//                   const Divider(height: 32),
//                   SafeArea(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('이 목표, 얼마나 달성하셨나요?',
//                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 12),
//
//                           RatingBar.builder(
//                             initialRating: 0,
//                             minRating: 1,
//                             direction: Axis.horizontal,
//                             allowHalfRating: false,
//                             itemCount: 5,
//                             itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//                             itemBuilder: (context, _) =>
//                             const Icon(Icons.star, color: Colors.amber),
//                             itemSize: 20,
//                             onRatingUpdate: (value) {
//                               setState(() {
//                                 rating = value;
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 16),
//
//                           TextField(
//                             controller: feedbackController,
//                             maxLines: 3,
//                             decoration: const InputDecoration(
//                               hintText: '목표에 대해 스스로에게 피드백을 남겨보세요',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: () async {
//                                 // TODO: 서버에 피드백 전송
//                                 // await ref.read(goalServiceProvider).submitFeedback(...);
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text('피드백이 저장되었어요!')),
//                                 );
//                               },
//                               child: const Text('피드백 저장'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../common/constants.dart';
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

            return Column(
              children: [
                // 1. 제목 고정
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

                // 2. 본문 내용 스크롤 가능
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

                // 3. 피드백 UI (DRAFT가 아닐 때만 노출)
                if (!isDraft)
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 텍스트 + 별점 한 줄
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '이 목표, 얼마나 달성하셨나요?',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              RatingBar.builder(
                                initialRating: rating,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding: EdgeInsets.zero, // 내부 간격 제거
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
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          TextField(
                            controller: feedbackController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: '목표에 대해 스스로에게 피드백을 남겨보세요',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary, // 버튼 배경색
                                foregroundColor: Colors.white,      // 텍스트 색
                              ),
                              onPressed: () async {
                                // TODO: 서버에 피드백 전송
                                // await ref.read(goalServiceProvider).submitFeedback(...);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('피드백이 저장되었어요!')),
                                );
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
