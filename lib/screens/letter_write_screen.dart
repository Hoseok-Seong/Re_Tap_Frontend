import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LetterWriteScreen extends StatefulWidget {
  const LetterWriteScreen({super.key});

  @override
  State<LetterWriteScreen> createState() => _LetterWriteScreenState();
}

class _LetterWriteScreenState extends State<LetterWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime? _selectedDate;

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

  void _saveLetter() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("제목, 내용, 날짜를 모두 입력해주세요")),
      );
      return;
    }

    // TODO: 나중에 API 호출 로직 추가 예정
    print("저장: ${_titleController.text}, ${_selectedDate.toString()}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("편지가 저장되었습니다!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : "도착 날짜 선택";

    return Scaffold(
      appBar: AppBar(title: const Text('편지 쓰기')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(dateStr),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveLetter,
              child: const Text('편지 저장'),
            )
          ],
        ),
      ),
    );
  }
}