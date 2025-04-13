import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import '../service/login_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final loginService = LoginService();

  Future<void> _loginWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
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

    await loginService.oauthLogin(
      provider: 'google',
      accessToken: accessToken,
    );

    context.go('/home'); // 임시 이동
  }

  Future<void> _loginWithKakao(BuildContext context) async {
    bool isInstalled = await isKakaoTalkInstalled();

    OAuthToken token;
    if (isInstalled) {
      token = await UserApi.instance.loginWithKakaoTalk();
    } else {
      token = await UserApi.instance.loginWithKakaoAccount();
    }

    User user = await UserApi.instance.me();
    final accessToken = token.accessToken;

    await loginService.oauthLogin(
      provider: 'kakao',
      accessToken: accessToken,
      profileImageUrl: user.properties?['profile_image'],
    );

    context.go('/home');
  }

  Future<void> _loginWithNaver(BuildContext context) async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status != NaverLoginStatus.loggedIn) {
      throw Exception('네이버 로그인 실패');
    }

    final account = result.account;
    final naverAccessToken = result.accessToken;

    await loginService.oauthLogin(
      provider: 'naver',
      accessToken: naverAccessToken.accessToken,
    );

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              '📨 Read Later',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '미래의 나에게 전하는 편지',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Spacer(),
            _SocialLoginButton(
              iconPath: 'assets/icons/google_icon.png',
              text: 'Google 로그인',
              backgroundColor: Color(0xFFF5F5F5),
              textColor: Colors.black,
              onTap: () => _loginWithGoogle(context),
              borderColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            _SocialLoginButton(
              iconPath: 'assets/icons/kakao_icon.png',
              text: '카카오 로그인',
              backgroundColor: const Color(0xFFFEE500),
              textColor: Colors.black,
              onTap: () => _loginWithKakao(context),
            ),
            const SizedBox(height: 12),
            _SocialLoginButton(
              iconPath: 'assets/icons/naver_icon.png',
              text: '네이버 로그인',
              backgroundColor: const Color(0xFF03C75A),
              textColor: Colors.white,
              onTap: () => _loginWithNaver(context),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 14),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
