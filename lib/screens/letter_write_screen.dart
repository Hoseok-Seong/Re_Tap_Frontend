import 'package:flutter/material.dart';
import 'package:future_letter/common/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dto/letter/letter_create_req.dart';
import '../dto/letter/letter_create_resp.dart';
import '../provider/letter_provider.dart';

class LetterWriteScreen extends ConsumerStatefulWidget {
  const LetterWriteScreen({super.key});

  @override
  ConsumerState<LetterWriteScreen> createState() => _LetterWriteScreenState();
}

class _LetterWriteScreenState extends ConsumerState<LetterWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLocked = false;
  int? _letterId;
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() => _isChanged = true));
    _contentController.addListener(() => setState(() => _isChanged = true));
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
        _isChanged = true;
      });
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
      _isChanged = false;
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

      // ✅ 상태 초기화
      _titleController.clear();
      _contentController.clear();
      _selectedDate = null;
      _isLocked = false;
      _letterId = null;
      _isChanged = false;

      context.go("/letters"); // 이동은 마지막에
    } catch (e) {
      _showSnack("부치기 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isChanged) {
          final discard = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("저장되지 않은 내용이 있어요"),
              content: const Text("저장하지 않으면 내용이 사라집니다. 그래도 이동하시겠습니까?"),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("취소")),
                ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("이동")),
              ],
            ),
          );
          return discard ?? false;
        }
        return true;
      },
      child: Scaffold(
        body: _buildFormBody(),
      ),
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

          // 제목
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '제목',
              hintText: '편지의 제목을 작성해 주세요',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // 내용
          TextField(
            controller: _contentController,
            maxLines: 15,
            decoration: const InputDecoration(
              labelText: '내용',
              hintText: '편지의 내용을 작성해 주세요',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),

          // 잠금 선택
          _inputCard(
            child: Column(
              children: [
                SwitchListTile(
                  value: _isLocked,
                  onChanged: (value) {
                    setState(() {
                      _isLocked = value;
                      _isChanged = true;
                      if (!value) _selectedDate = null;
                    });
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

