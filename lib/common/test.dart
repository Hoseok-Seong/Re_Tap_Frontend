import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../common/constants.dart';
import '../provider/letter_provider.dart';

class LetterListScreen extends ConsumerStatefulWidget {
  const LetterListScreen({super.key});

  @override
  ConsumerState<LetterListScreen> createState() => _LetterListScreenState();
}

class _LetterListScreenState extends ConsumerState<LetterListScreen> {
  bool _refreshed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 화면 처음 들어올 때만 invalidate
    if (!_refreshed) {
      ref.invalidate(letterListProvider);
      _refreshed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final letterListAsync = ref.watch(letterListProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: letterListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('에러 발생: $err')),
        data: (letters) {
          if (letters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('아직 작성한 편지가 없어요', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.go('/write');
                    },
                    child: const Text(
                      '편지 쓰러 가기 →',
                      style: TextStyle(fontSize: 16, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(left: 4, right: 4, bottom: 16),
            itemCount: letters.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final letter = letters[index];
              final hasArrivalDate = letter.arrivalDate != null;
              final arrivalStr = hasArrivalDate
                  ? DateFormat('yyyy-MM-dd').format(letter.arrivalDate!)
                  : '';
              final createdStr = DateFormat('yyyy-MM-dd').format(letter.createdDate);

              IconData icon;
              Color iconColor;
              String statusText;

              switch (letter.status) {
                case 'DRAFT':
                  icon = Icons.edit;
                  iconColor = Colors.blue;
                  statusText = '(임시저장)';
                  break;
                case 'SCHEDULED':
                  final hasArrivalDate = letter.arrivalDate != null;
                  final isFutureArrival = hasArrivalDate && letter.arrivalDate!.isAfter(DateTime.now());

                  if (isFutureArrival) {
                    icon = Icons.lock;
                    iconColor = Colors.grey;
                    statusText = '(예약발송)';
                  } else {
                    icon = Icons.lock_open;
                    iconColor = AppColors.primary;
                    statusText = '(도착완료)';
                  }
                  break;
                case 'DELIVERED':
                  icon = Icons.mark_email_unread;
                  iconColor = AppColors.primary;
                  statusText = '(도착완료)';
                  break;
                case 'READ':
                  icon = Icons.mark_email_read;
                  iconColor = AppColors.primary;
                  statusText = '(읽은편지)';
                  break;
                default:
                  icon = Icons.mail_outline;
                  iconColor = Colors.black26;
                  statusText = '';
              }

              return GestureDetector(
                onTap: () {
                  final isDraft = letter.status == 'DRAFT';
                  final isScheduled = letter.status == 'SCHEDULED';
                  final hasArrivalDate = letter.arrivalDate != null;
                  final isFutureArrival = hasArrivalDate && letter.arrivalDate!.isAfter(DateTime.now());

                  if (isDraft) {
                    Future.microtask(() {
                      context.push('/write', extra: letter);
                      //context.go('/main?tab=1', extra: letter);
                    });
                  } else if (isScheduled && isFutureArrival) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('아직 열 수 없어요'),
                        content: const Text('설정한 도착일 이후에 열람할 수 있습니다.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      ),
                    );
                  }
                  else {
                    context.pushNamed(
                      'detail',
                      pathParameters: {'id': letter.letterId.toString()},
                    );
                  }
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        letter.title,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '작성일자: $createdStr',
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                      if (letter.arrivalDate != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          '도착일자: $arrivalStr',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      statusText,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: iconColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      letter.isLocked ? '잠금편지 🔒' : '일반편지',
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      letter.isRead ? '읽음' : ' ',
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}