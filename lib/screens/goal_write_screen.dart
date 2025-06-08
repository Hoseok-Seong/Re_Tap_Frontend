import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/constants.dart';
import '../dto/goal/goal_create_req.dart';
import '../dto/goal/goal_list_resp.dart';
import '../provider/goal_provider.dart';
import '../provider/home_provider.dart';

class GoalWriteScreen extends ConsumerStatefulWidget {
  final GoalSummary? goal;

  const GoalWriteScreen({super.key, this.goal});

  @override
  ConsumerState<GoalWriteScreen> createState() => _GoalWriteScreenState();
}

class _GoalWriteScreenState extends ConsumerState<GoalWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLocked = false;
  int? _goalId;

  @override
  void initState() {
    super.initState();

    final goal = widget.goal;
    if (goal != null) {
      _goalId = goal.goalId;
      _titleController.text = goal.title;
      _contentController.text = goal.content;
      _isLocked = goal.isLocked;
      _selectedDate = goal.arrivalDate;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }

    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  void _onChanged() {
    if (!ref.read(goalEditChangedProvider)) {
      ref.read(goalEditChangedProvider.notifier).state = true;
    }
    setState(() {});
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      ref.read(goalEditChangedProvider.notifier).state = true;
    }
  }

  Future<void> _saveTempGoal() async {
    if (!_isValid()) return;

    final req = GoalCreateReq(
      goalId: _goalId,
      title: _titleController.text,
      content: _contentController.text,
      isLocked: _isLocked,
      arrivalDate: _isLocked ? _selectedDate : null,
      isSend: false,
    );

    try {
      final resp = await ref.read(createOrUpdateGoalProvider(req).future);
      _goalId ??= resp.goalId;
      ref.read(goalEditChangedProvider.notifier).state = false;
      _showSnack("임시 저장 완료");
    } catch (e) {
      _showSnack("저장 실패: $e");
    }
  }

  Future<void> _saveGoal() async {
    if (!_isValid()) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("목표를 저장할까요?"),
        content: const Text("저장 후에는 수정할 수 없어요."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("취소")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("저장")),
        ],
      ),
    );

    if (confirm != true) return;

    final req = GoalCreateReq(
      goalId: _goalId,
      title: _titleController.text,
      content: _contentController.text,
      isLocked: _isLocked,
      arrivalDate: _selectedDate,
      isSend: true,
    );

    try {
      await ref.read(createOrUpdateGoalProvider(req).future);
      _showSnack("목표를 저장했습니다!");

      _resetState();
      ref.invalidate(goalListProvider);
      ref.invalidate(homeProvider);
      context.go("/goals");
    } catch (e) {
      _showSnack("저장이 실패하였습니다. 다시 시도해주세요.");
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(resetGoalWriteProvider, (previous, next) {
      if (next == true) {
        _resetState();
        ref.read(resetGoalWriteProvider.notifier).state = false;
      }
    });
    return WillPopScope(
      onWillPop: () async {
        final isChanged = ref.read(goalEditChangedProvider);

        if (isChanged) {
          final discard = await showDiscardConfirmDialog(context, _resetState);
          return discard;
        }
        return true;
      },
      child: _buildFormBody(),
    );
  }

  Widget _buildFormBody() {
    final dateStr = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : "알림일자 선택";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오늘의 목표, 미래를 바꿀 수 있어요',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // 제목 글자수
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${_titleController.text.characters.length} / 50',
                style: TextStyle(
                  fontSize: 12,
                  color: _titleController.text.characters.length >= 45 ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 제목 입력
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              labelText: '제목',
              hintText: '목표의 제목을 작성해 주세요',
              border: OutlineInputBorder(),
              counterText: "",
            ),
          ),
          const SizedBox(height: 16),

          // 내용 글자수
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${_contentController.text.characters.length} / 2000',
                style: TextStyle(
                  fontSize: 12,
                  color: _contentController.text.characters.length >= 1800 ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 내용 입력
          TextField(
            controller: _contentController,
            maxLines: 15,
            maxLength: 2000,
            decoration: const InputDecoration(
              labelText: '내용',
              hintText: '목표의 내용을 작성해 주세요',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
              counterText: "",
            ),
          ),
          const SizedBox(height: 16),

          // 잠금 편지 설정
          _inputCard(
            child: Column(
              children: [
                SwitchListTile(
                  value: _isLocked,
                  onChanged: (value) {
                    setState(() {
                      _isLocked = value;
                    });
                    ref.read(goalEditChangedProvider.notifier).state = true;
                  },
                  title: const Text(
                    '잠금 목표로 작성할까요? 🔒',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('알림일자까지 내용을 볼 수 없어요.', style: TextStyle(fontSize: 12)),
                ),
                ListTile(
                  title: Text(dateStr),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _pickDate,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 버튼
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  onPressed: _saveTempGoal,
                  child: const Text('임시 저장', style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: _saveGoal,
                  child: const Text('최종 저장'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _inputCard({required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  Future<bool> showDiscardConfirmDialog(BuildContext context, VoidCallback onDiscard) async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("저장되지 않은 내용이 있어요", style: TextStyle(fontSize: 20)),
        content: const Text("저장하지 않으면 작성한 내용이 사라집니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("취소"),
          ),
          ElevatedButton(
            onPressed: () {
              onDiscard();
              Navigator.pop(context, true);
            },
            child: const Text("이동"),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  void _resetState() {
    _titleController.clear();
    _contentController.clear();
    _selectedDate = null;
    _isLocked = false;
    _goalId = null;
    ref.read(goalEditChangedProvider.notifier).state = false;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _isValid() {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      _showSnack("제목과 내용을 모두 입력해주세요");
      return false;
    }

    if (_isLocked && _selectedDate == null) {
      _showSnack("잠금 목표의 경우 알림일자를 선택해주세요");
      return false;
    }

    return true;
  }
}

