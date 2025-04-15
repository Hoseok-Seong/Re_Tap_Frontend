import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../common/constants.dart';
import 'home_screen.dart';
import 'letter_list_screen.dart';
import 'letter_write_screen.dart';
import 'my_page_screen.dart';

class MainLayout extends StatelessWidget {
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          children: [
            // Image.asset('assets/icons/naver_icon.png', width: 28),
            const Text('📨'),
            const SizedBox(width: 8),
            const Text(
              'Read Later',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              context.go('/notification');  // 알림 페이지
            },
          )
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: const [
            HomeScreen(),
            LetterWriteScreen(),
            LetterListScreen(),
            MyPageScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.text.withOpacity(0.5),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/write');
              break;
            case 2:
              context.go('/letters');
              break;
            case 3:
              context.go('/mypage');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: '편지 쓰기'),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: '편지함'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}
