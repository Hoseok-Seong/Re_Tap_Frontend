import 'package:flutter/material.dart';
import 'package:future_letter/common/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:future_letter/dto/letter/letter_create_req.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    }
  }

  // void _saveLetter() {
  //   if (_titleController.text.isEmpty ||
  //       _contentController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("제목, 내용을 모두 입력해주세요")),
  //     );
  //     return;
  //   }
  //
  //   print("제목: ${_titleController.text}");
  //   print("내용: ${_contentController.text}");
  //   print("도착날짜: $_selectedDate");
  //   print("잠금여부: $_isLocked");
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("편지가 저장되었습니다!")),
  //   );
  //   context.pop();
  // }
  void _saveLetter() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("제목, 내용을 모두 입력해주세요")),
      );
      return;
    }

    final req = LetterCreateReq(
      title: _titleController.text,
      content: _contentController.text,
      isLocked: _isLocked,
      arrivalDate: _isLocked ? _selectedDate : null,
      isSend: true, // 진짜 부치는 편지
    );

    try {
      final letterId = await ref.read(createLetterProvider(req).future);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("편지가 저장되었습니다!")),
      );

      context.pop(); // 뒤로 가기
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("오류 발생: $e")),
      );
    }
  }


  // void _saveTempLetter() {
  //   if (_titleController.text.isEmpty ||
  //       _contentController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("제목, 내용을 모두 입력해주세요")),
  //     );
  //     return;
  //   }
  //
  //   print("제목: ${_titleController.text}");
  //   print("내용: ${_contentController.text}");
  //   print("도착날짜: $_selectedDate");
  //   print("잠금여부: $_isLocked");
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("편지가 저장되었습니다!")),
  //   );
  //   context.pop();
  // }

  void _saveTempLetter() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("제목, 내용을 모두 입력해주세요")),
      );
      return;
    }

    final req = LetterCreateReq(
      title: _titleController.text,
      content: _contentController.text,
      isLocked: _isLocked,
      arrivalDate: _isLocked ? _selectedDate : null,
      isSend: false, // 임시저장
    );

    try {
      final letterId = await ref.read(createLetterProvider(req).future);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("임시 저장 완료!")),
      );

      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("오류 발생: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final dateStr = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : "도착 날짜 선택";

    return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('미래의 나에게 남기고 싶은 이야기가 있나요?',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
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

            // 잠금 선택 카드
            _inputCard(
              child: Column(
                children: [
                  SwitchListTile(
                    value: _isLocked,
                    onChanged: (value) {
                      setState(() {
                        _isLocked = value;
                        if (!value) _selectedDate = null; // 잠금 해제 시 날짜 초기화
                      });
                    },
                    title: const Text('잠금 편지로 작성할까요? 🔒', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                    subtitle: const Text('도착일까지 내용을 볼 수 없어요.', style: TextStyle(fontSize: 12)),
                  ),
                  if (_isLocked)
                    ListTile(
                      title: Text(
                        _selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                            : "도착 날짜 선택",
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _pickDate,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300], // 임시저장은 살짝 옅은 색
                    ),
                    onPressed: _saveTempLetter,
                    child: const Text('임시 저장', style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, // 메인 컬러
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
}
