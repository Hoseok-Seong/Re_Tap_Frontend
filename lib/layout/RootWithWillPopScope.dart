import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RootWithWillPopScope extends StatefulWidget {
  final Widget child;

  const RootWithWillPopScope({super.key, required this.child});

  @override
  State<RootWithWillPopScope> createState() => _RootWithWillPopScopeState();
}

class _RootWithWillPopScopeState extends State<RootWithWillPopScope> {
  DateTime? _lastBackPressed;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
          _lastBackPressed = now;
          Fluttertoast.showToast(msg: '한 번 더 누르면 종료됩니다');
          return false;
        }
        return true;
      },
      child: widget.child,
    );
  }
}
