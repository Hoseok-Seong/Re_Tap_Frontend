import 'package:flutter/material.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const FutureLetterApp());
}

class FutureLetterApp extends StatelessWidget {
  const FutureLetterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FutureLetter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: AppRouter.router,
    );
  }
}