import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'routes/app_router.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

void main() async{
  await dotenv.load(fileName: 'config/.env');

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: dotenv.env['kakao_nativeAppKey'],
  );

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