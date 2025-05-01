import 'package:flutter/material.dart';
import 'package:future_letter/common/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dto/letter/letter_create_req.dart';
import '../dto/letter/letter_list_resp.dart';
import '../provider/letter_provider.dart';

class LetterWriteScreen extends ConsumerStatefulWidget {
  final LetterSummary? letter;

  const LetterWriteScreen({super.key, this.letter});

  @override
  ConsumerState<LetterWriteScreen> createState() => _LetterWriteScreenState();
}

class _LetterWriteScreenState extends ConsumerState<LetterWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLocked = false;
  int? _letterId;

  @override
  void initState() {
    super.initState();

    final letter = widget.letter;
    if (letter != null) {
      _letterId = letter.letterId;
      _titleController.text = letter.title;
      _contentController.text = letter.content;
      _isLocked = letter.isLocked;
      _selectedDate = letter.arrivalDate;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }

    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  void _onChanged() {
    if (!ref.read(letterEditChangedProvider)) {
      ref.read(letterEditChangedProvider.notifier).state = true;
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
      ref.read(letterEditChangedProvider.notifier).state = true;
    }
  }

  Future<void> _saveTempLetter() async {
    if (!_isValid()) return;

    final req = LetterCreateReq(
      letterId: _letterId,
      title: _titleController.text,
      content: _contentController.text,
      isLocked: _isLocked,
      arrivalDate: _isLocked ? _selectedDate : null,
      isSend: false,
    );

    try {
      final resp = await ref.read(createOrUpdateLetterProvider(req).future);
      _letterId ??= resp.letterId;
      ref.read(letterEditChangedProvider.notifier).state = false;
      _showSnack("임시 저장 완료");
    } catch (e) {
      _showSnack("저장 실패: $e");
    }
  }

  Future<void> _saveLetter() async {
    if (!_isValid()) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("편지를 부치시겠어요?"),
        content: const Text("부친 후에는 수정할 수 없어요."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("취소")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("부치기")),
        ],
      ),
    );

    if (confirm != true) return;

    final req = LetterCreateReq(
      letterId: _letterId,
      title: _titleController.text,
      content: _contentController.text,
      isLocked: _isLocked,
      arrivalDate: _isLocked ? _selectedDate : null,
      isSend: true,
    );

    try {
      await ref.read(createOrUpdateLetterProvider(req).future);
      _showSnack("편지를 부쳤습니다!");

      _resetState();
      ref.invalidate(letterListProvider);
      context.go("/letters");
    } catch (e) {
      _showSnack("부치기 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(resetLetterWriteProvider, (previous, next) {
      if (next == true) {
        _resetState();
        ref.read(resetLetterWriteProvider.notifier).state = false;
      }
    });
    return WillPopScope(
      onWillPop: () async {
        final isChanged = ref.read(letterEditChangedProvider);

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
        : "도착 날짜 선택";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '미래의 나에게 남기고 싶은 이야기가 있나요?',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // 제목 글자수
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${_titleController.text.length} / 50',
                style: TextStyle(
                  fontSize: 12,
                  color: _titleController.text.length >= 45 ? Colors.red : Colors.grey,
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
              hintText: '편지의 제목을 작성해 주세요',
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
                '${_contentController.text.length} / 2000',
                style: TextStyle(
                  fontSize: 12,
                  color: _contentController.text.length >= 1800 ? Colors.red : Colors.grey,
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
              hintText: '편지의 내용을 작성해 주세요',
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
                      if (!value) _selectedDate = null;
                    });
                    ref.read(letterEditChangedProvider.notifier).state = true;
                  },
                  title: const Text(
                    '잠금 편지로 작성할까요? 🔒',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('도착일까지 내용을 볼 수 없어요.', style: TextStyle(fontSize: 12)),
                ),
                if (_isLocked)
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
                  onPressed: _saveTempLetter,
                  child: const Text('임시 저장', style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: _saveLetter,
                  child: const Text('편지 부치기'),
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
    _letterId = null;
    ref.read(letterEditChangedProvider.notifier).state = false;
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
      _showSnack("잠금 편지의 경우 도착 날짜를 선택해주세요");
      return false;
    }

    return true;
  }
}

