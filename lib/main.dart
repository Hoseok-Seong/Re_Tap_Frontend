import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'routes/app_router.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  await dotenv.load(fileName: 'config/.env');

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: dotenv.env['kakao_nativeAppKey'],
  );

  runApp(ProviderScope(child: FutureLetterApp()));
}

class FutureLetterApp extends ConsumerWidget {
  const FutureLetterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FutureLetter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: AppRouter.router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),  // 한국어
        Locale('en', 'US'),  // 영어
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // 디바이스 언어 기반 매칭
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        // 기본값
        return supportedLocales.first;
      },
    );
  }
}