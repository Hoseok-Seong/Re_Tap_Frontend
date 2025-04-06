import 'package:flutter/material.dart';

class LetterDetailScreen extends StatelessWidget {
  final String letterId;
  const LetterDetailScreen({super.key, required this.letterId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Letter Detail: $letterId'),
      ),
    );
  }
}
