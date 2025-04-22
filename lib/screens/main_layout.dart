import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../common/constants.dart';
import 'home_screen.dart';
import 'letter_list_screen.dart';
import 'letter_write_screen.dart';
import 'my_page_screen.dart';

class MainLayout extends StatefulWidget {
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.currentIndex,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey _writeKey = GlobalKey();
  final GlobalKey _lettersKey = GlobalKey();
  final GlobalKey _notificationKey = GlobalKey();

  late BuildContext myShowCaseContext;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _maybeShowGuide);
  }

  Future<void> _maybeShowGuide() async {
    // final prefs = await SharedPreferences.getInstance();
    // // final hasShownGuide = prefs.getBool('hasShownGuide') ?? false;
    // final hasShownGuide = false;
    //
    // if (!hasShownGuide && mounted) {
    //   await Future.delayed(const Duration(milliseconds: 300));
    //
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     ShowCaseWidget.of(myShowCaseContext).startShowCase([
    //       _writeKey,
    //       _lettersKey,
    //       _notificationKey,
    //     ]);
    //   });
    //
    //   await prefs.setBool('hasShownGuide', true);
    // }
    final prefs = await SharedPreferences.getInstance();
    final hasShownGuide = prefs.getBool('hasShownGuide') ?? false;

    if (hasShownGuide) return; // 이미 본 경우 종료

    await Future.delayed(const Duration(milliseconds: 300));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(myShowCaseContext).startShowCase([
        _writeKey,
        _lettersKey,
        _notificationKey,
      ]);
    });

    await prefs.setBool('hasShownGuide', true); // 이후에는 안 보이게
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (showCaseContext) {
          myShowCaseContext = showCaseContext;

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Row(
                children: const [
                  Text('📨'),
                  SizedBox(width: 8),
                  Text(
                    'Read Later',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                Showcase(
                  key: _notificationKey,
                  description: '새로운 편지가 도착하면 종이 반짝여요!',
                  descTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  tooltipBackgroundColor: Colors.white,
                  overlayColor: Colors.black.withOpacity(0.7),
                  targetPadding: const EdgeInsets.all(2),
                  showArrow: false,
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.black),
                    onPressed: () {
                      context.go('/notification');
                    },
                  ),
                )
              ],
            ),
            body: SafeArea(
              child: IndexedStack(
                index: widget.currentIndex,
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
              currentIndex: widget.currentIndex,
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
              items: [
                const BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
                BottomNavigationBarItem(
                  icon: Showcase(
                    key: _writeKey,
                    description: '여기서 미래의 나에게 편지를 쓸 수 있어요.',
                    descTextStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    tooltipBackgroundColor: Colors.white,
                    overlayColor: Colors.black.withOpacity(0.7),
                    targetPadding: const EdgeInsets.all(18),
                    child: const Icon(Icons.edit),
                  ),
                  label: '편지 쓰기',
                ),
                BottomNavigationBarItem(
                  icon: Showcase(
                    key: _lettersKey,
                    description: '내가 보낸 편지를 한 눈에 확인할 수 있어요.',
                    descTextStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    tooltipBackgroundColor: Colors.white,
                    overlayColor: Colors.black.withOpacity(0.7),
                    targetPadding: const EdgeInsets.all(18),
                    child: const Icon(Icons.mail),
                  ),
                  label: '편지함',
                ),
                const BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
              ],
            ),
          );
        },
      ),
    );
  }
}
