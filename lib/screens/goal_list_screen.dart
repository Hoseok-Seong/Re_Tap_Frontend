import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../common/constants.dart';
import '../provider/goal_provider.dart';
import '../provider/home_provider.dart';

class GoalListScreen extends ConsumerStatefulWidget {
  const GoalListScreen({super.key});

  @override
  ConsumerState<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends ConsumerState<GoalListScreen> {
  bool _refreshed = false;
  bool _isSelectMode = false;
  final Set<int> _selectedGoalIds = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_refreshed) {
      ref.invalidate(goalListProvider);
      _refreshed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalListAsync = ref.watch(goalListProvider);

    return WillPopScope(
      onWillPop: () async {
        if (_isSelectMode) {
          setState(() {
            _isSelectMode = false;
            _selectedGoalIds.clear();
          });
          return false;
        }
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: goalListAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('목표 리스트 데이터를 불러오지 못했어요')),
              );
            });

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('아직 작성한 목표가 없어요', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/write'),
                    child: const Text(
                      '목표 작성하기',
                      style: TextStyle(fontSize: 16, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            );
          },
          data: (goals) {
            if (goals.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('아직 작성한 목표가 없어요', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.go('/write'),
                      child: const Text(
                        '목표 작성하기',
                        style: TextStyle(fontSize: 16, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                ListView.separated(
                  padding: EdgeInsets.only(
                    left: 4,
                    right: 4,
                    bottom: _isSelectMode && _selectedGoalIds.isNotEmpty ? 100 : 16,
                  ),
                  itemCount: goals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    final arrivalStr = goal.arrivalDate != null
                        ? DateFormat('yyyy-MM-dd').format(goal.arrivalDate!)
                        : '';
                    final createdStr = DateFormat('yyyy-MM-dd').format(goal.createdDate);

                    IconData icon;
                    Color iconColor;
                    String statusText;

                    switch (goal.status) {
                      case 'DRAFT':
                        icon = Icons.edit;
                        iconColor = Colors.blue;
                        statusText = '(임시저장)';
                        break;
                      case 'SCHEDULED':
                        final isFutureArrival = goal.arrivalDate != null &&
                            goal.arrivalDate!.isAfter(DateTime.now());
                        icon = Icons.schedule;
                        iconColor = isFutureArrival ? Colors.grey : AppColors.primary;
                        statusText = isFutureArrival ? '(예약발송)' : '(도착완료)';
                        break;
                      case 'DELIVERED':
                        icon = Icons.mark_email_unread;
                        iconColor = AppColors.primary;
                        statusText = '(도착완료)';
                        break;
                      default:
                        icon = Icons.mail_outline;
                        iconColor = Colors.black26;
                        statusText = '';
                    }

                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _isSelectMode = true;
                          _selectedGoalIds.add(goal.goalId);
                        });
                      },
                      onTap: () async {
                        if (_isSelectMode) {
                          setState(() {
                            if (_selectedGoalIds.contains(goal.goalId)) {
                              _selectedGoalIds.remove(goal.goalId);
                            } else {
                              _selectedGoalIds.add(goal.goalId);
                            }

                            if (_selectedGoalIds.isEmpty) {
                              _isSelectMode = false;
                            }
                          });
                          return;
                        }

                        final isDraft = goal.status == 'DRAFT';
                        final isScheduled = goal.status == 'SCHEDULED';
                        final isFutureArrival = goal.arrivalDate != null &&
                            goal.arrivalDate!.isAfter(DateTime.now());
                        final isLocked = goal.isLocked;

                        if (isDraft) {
                          context.push('/write', extra: goal);
                        } else if (isScheduled && isFutureArrival && isLocked) {
                          await Future.delayed(Duration.zero);
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('아직 열 수 없어요'),
                              content: const Text('설정한 알림일자 이후에 열람할 수 있습니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('확인'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          context.pushNamed(
                            'detail',
                            pathParameters: {'id': goal.goalId.toString()},
                          );
                        }
                      },
                      child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_isSelectMode)
                                    Checkbox(
                                      value: _selectedGoalIds.contains(goal.goalId),
                                      onChanged: (checked) {
                                        setState(() {
                                          if (checked == true) {
                                            _selectedGoalIds.add(goal.goalId);
                                          } else {
                                            _selectedGoalIds.remove(goal.goalId);
                                          }

                                          if (_selectedGoalIds.isEmpty) {
                                            _isSelectMode = false;
                                          }
                                        });
                                      },
                                    ),
                                  Icon(icon, color: iconColor),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          goal.title,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '작성일자: $createdStr',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                        if (goal.arrivalDate != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            '알림일자: $arrivalStr',
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                        ],
                                        const SizedBox(height: 12),

                                        if (goal.score != null)
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                '피드백 점수:',
                                                style: TextStyle(fontSize: 12, color: Colors.grey),
                                              ),
                                              const SizedBox(width: 4),
                                              RatingBarIndicator(
                                                rating: goal.score!.toDouble(),
                                                itemCount: 5,
                                                itemSize: 16,
                                                itemBuilder: (context, _) =>
                                                const Icon(Icons.star, color: Colors.amber),
                                              ),
                                            ],
                                          ),
                                        if (goal.score == null)
                                          const Text('성장 피드백이 아직 없어요 🌱', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(statusText, style: TextStyle(fontSize: 12, color: iconColor)),
                                      const SizedBox(height: 2),
                                      Text(goal.isLocked ? '잠금목표 🔒' : '일반목표',
                                          style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                      const SizedBox(height: 2),
                                      Text(goal.isRead ? '읽음' : ' ', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    context.push('/write', extra: goal);
                                  } else if (value == 'delete') {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('삭제 확인'),
                                        content: const Text('이 목표를 삭제할까요?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('취소'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('삭제', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      try {
                                        await ref.read(goalDeleteProvider([goal.goalId]).future);
                                        ref.invalidate(goalListProvider);
                                        ref.invalidate(homeProvider);

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('목표가 삭제되었습니다.')),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('삭제가 실패하였습니다. 다시 시도해주세요.')),
                                        );
                                      }
                                    }
                                  }
                                },
                                itemBuilder: (context) {
                                  final items = <PopupMenuEntry<String>>[];

                                  // 수정 버튼: 잠금 상태 아니고, score 없을 때만
                                  if (!goal.isLocked && goal.score == null) {
                                    items.add(
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('수정', style: TextStyle(color: Colors.orange)),
                                      ),
                                    );
                                  }

                                  // 삭제 버튼은 항상 보임
                                  items.add(
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('삭제', style: TextStyle(color: Colors.red)),
                                    ),
                                  );

                                  return items;
                                },
                                icon: const Icon(Icons.more_horiz, size: 20, color: Colors.grey),
                              ),
                            )
                          ]
                      ),
                    );
                  },
                ),
                if (_isSelectMode && _selectedGoalIds.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isSelectMode = false;
                                _selectedGoalIds.clear();
                              });
                            },
                            icon: const Icon(Icons.close),
                            label: const Text('선택 해제'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[600],
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('삭제 확인'),
                                  content: Text('${_selectedGoalIds.length}개의 목표를 삭제할까요?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('취소'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('삭제'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm != true) return;

                              try {
                                await ref.read(goalDeleteProvider(_selectedGoalIds.toList()).future);

                                setState(() {
                                  _isSelectMode = false;
                                  _selectedGoalIds.clear();
                                });

                                ref.invalidate(homeProvider);
                                ref.invalidate(goalListProvider);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('목표가 삭제되었습니다.')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('삭제가 실패하였습니다. 다시 시도해주세요.')),
                                );
                              }
                            },
                            icon: const Icon(Icons.delete),
                            label: Text('삭제 (${_selectedGoalIds.length})'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
