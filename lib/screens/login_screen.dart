import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import '../common/constants.dart';
import '../dto/auth/oauth_check_req.dart';
import '../dto/user/fcm_token_req.dart';
import '../provider/auth_provider.dart';
import '../provider/user_provider.dart';
import '../service/auth_service.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final authService = AuthService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'ReTap',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              '목표를 남기고, 다시 확인하는 습관',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const Spacer(),
            _SocialLoginButton(
              iconPath: 'assets/icons/google_icon2.png',
              text: '구글로 로그인',
              backgroundColor: Colors.white70,
              textColor: Colors.black,
              onTap: () => _loginWithGoogle(context, ref),
              borderColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            _SocialLoginButton(
              iconPath: 'assets/icons/kakao_icon2.png',
              text: '카카오 로그인',
              backgroundColor: const Color(0xFFFEE500),
              textColor: Colors.black,
              onTap: () => _loginWithKakao(context, ref),
            ),
            const SizedBox(height: 12),
            _SocialLoginButton(
              iconPath: 'assets/icons/naver_icon.png',
              text: '네이버 로그인',
              backgroundColor: const Color(0xFF03C75A),
              textColor: Colors.white,
              onTap: () => _loginWithNaver(context, ref),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> registerFcmToken(WidgetRef ref) async {
    final token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      final req = FcmTokenReq(fcmToken: token);

      try {
        await ref.read(updateFcmTokenProvider(req).future);
        print('✅ FCM 토큰 서버에 전송 완료');
      } catch (e) {
        print('❌ FCM 토큰 전송 실패: $e');
      }
    }
  }

  Future<void> _loginWithGoogle(BuildContext context, WidgetRef ref) async {
    final clientId = dotenv.env['google_oauth_client_id'];

    final GoogleSignIn googleSignIn = GoogleSignIn(clientId: clientId);
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      // 로그인 취소됨
      return;
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;

    if (accessToken == null) {
      throw Exception('Google AccessToken 없음');
    }

    final response = await authService.checkUser(
      provider: 'google',
      accessToken: accessToken,
    );

    if (response.isNewUser) {
      context.go('/agreement', extra: OauthCheckReq(provider: 'google', accessToken: accessToken));
    } else {
      await authService.oauthLogin(
        provider: 'google',
        accessToken: accessToken,
      );
      ref.read(authStateProvider.notifier).state = AuthState.loggedIn;

      registerFcmToken(ref);

      context.go('/home');
    }
  }

  Future<void> _loginWithKakao(BuildContext context, WidgetRef ref) async {
    bool isInstalled = await isKakaoTalkInstalled();

    OAuthToken token;
    if (isInstalled) {
      token = await UserApi.instance.loginWithKakaoTalk();
    } else {
      token = await UserApi.instance.loginWithKakaoAccount();
    }

    final accessToken = token.accessToken;

    final response = await authService.checkUser(
      provider: 'kakao',
      accessToken: accessToken,
    );

    if (response.isNewUser) {
      context.go('/agreement', extra: OauthCheckReq(provider: 'kakao', accessToken: accessToken));
    } else {
      await authService.oauthLogin(
        provider: 'kakao',
        accessToken: accessToken,
      );
      ref.read(authStateProvider.notifier).state = AuthState.loggedIn;

      registerFcmToken(ref);

      context.go('/home');
    }
  }

  Future<void> _loginWithNaver(BuildContext context, WidgetRef ref) async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status != NaverLoginStatus.loggedIn) {
      throw Exception('네이버 로그인 실패');
    }

    final accessToken = result.accessToken.accessToken;

    final response = await authService.checkUser(
      provider: 'naver',
      accessToken: accessToken,
    );

    if (response.isNewUser) {
      context.go('/agreement', extra: OauthCheckReq(provider: 'naver', accessToken: accessToken));
    } else {
      await authService.oauthLogin(
        provider: 'naver',
        accessToken: accessToken,
      );
      ref.read(authStateProvider.notifier).state = AuthState.loggedIn;

      registerFcmToken(ref);

      context.go('/home');
    }
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  const _SocialLoginButton({
    required this.iconPath,
    required this.text,
    required this.onTap,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
