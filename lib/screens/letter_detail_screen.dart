// import 'package:flutter/material.dart';
// import 'package:future_letter/common/constants.dart';
// import 'package:intl/intl.dart';
// import '../dto/letter/letter.dart';
//
// class LetterDetailScreen extends StatelessWidget {
//   final String letterId;
//   const LetterDetailScreen({super.key, required this.letterId});
//
//   // 임시 mock 데이터
//   Letter getMockLetter(String id) {
//     final now = DateTime.now();
//
//     return Letter(
//       id: id,
//       title: '2024년의 나에게 보내는 편지',
//       content: '잘 지내고 있지?\n그때의 너가 자랑스러웠으면 좋겠다.\n계속 앞으로 나아가자!',
//       openDate: now.subtract(const Duration(days: 1)),
//       isOpened: true,
//       status: 'sent',
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final letter = getMockLetter(letterId);
//     final isLocked = !letter.isOpened;
//     final dateStr = DateFormat('yyyy-MM-dd').format(letter.openDate);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         title: Row(
//           children: [
//             const Text(
//               'Read Later',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: isLocked
//             ? Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.lock, size: 64, color: Colors.grey),
//               const SizedBox(height: 16),
//               Text(
//                 "이 편지는 아직 열 수 없어요.\n열람 가능일: $dateStr",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ],
//           ),
//         )
//             : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   letter.title,
//                   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const Divider(height: 32),
//                 Text(
//                     (letter.content.trim().isEmpty) ? '(내용 없음)' : letter.content,
//                     style: const TextStyle(fontSize: 16, height: 1.5),
//                 ),
//               ],
//             ),
//       ),
//     );
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_letter/common/constants.dart';
import '../provider/letter_provider.dart';
import 'package:go_router/go_router.dart';

class LetterDetailScreen extends ConsumerWidget {
  final String letterId;
  const LetterDetailScreen({super.key, required this.letterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final letterDetail = ref.watch(letterDetailProvider(int.parse(letterId)));

    return Scaffold(
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
        )
    );
  }
}
