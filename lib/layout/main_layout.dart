import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../common/constants.dart';
import '../dto/goal/goal_list_resp.dart';
import '../notification/notification_service.dart';
import '../provider/goal_provider.dart';
import '../provider/home_provider.dart';
import '../provider/my_page_provider.dart';
import '../screens/goal_list_screen.dart';
import '../screens/goal_write_screen.dart';
import '../screens/home_screen.dart';
import '../screens/my_page_screen.dart';

class MainLayout extends ConsumerStatefulWidget {
  final int currentIndex;
  final GoalSummary? goal;

  const MainLayout({super.key, required this.currentIndex, this.goal});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  final GlobalKey _writeKey = GlobalKey();
  final GlobalKey _goalsKey = GlobalKey();
  final GlobalKey _notificationKey = GlobalKey();

  late BuildContext myShowCaseContext;

  late int _currentIndex;

  bool _hasPlayedBellAnimation = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;

    Future.microtask(() => ref.read(homeProvider.future));

    Future.delayed(Duration.zero, _maybeShowGuide);

    requestNotificationPermission();
  }

  Future<void> _loadBellAnimationFlag() async {
    final prefs = await SharedPreferences.getInstance();
    _hasPlayedBellAnimation = prefs.getBool('hasPlayedBellAnimation') ?? false;
  }

  Future<void> _maybeShowGuide() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownGuide = prefs.getBool('hasShownGuide') ?? false;

    if (hasShownGuide) return; // 이미 본 경우 종료

    await Future.delayed(const Duration(milliseconds: 300));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(myShowCaseContext).startShowCase([
        _writeKey,
        _goalsKey,
        _notificationKey,
      ]);
    });

    await prefs.setBool('hasShownGuide', true); // 이후에는 안 보이게
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final unreadCount = homeState.maybeWhen(
      data: (data) => data.unreadCount,
      orElse: () => 0,
    );

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
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.primary,
              elevation: 0,
              centerTitle: true,
              title: const Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    'ReTap',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final homeState = ref.watch(homeProvider);
                      final unreadCount = homeState.maybeWhen(
                        data: (data) => data.unreadCount,
                        orElse: () => 0,
                      );

                      if (!_hasPlayedBellAnimation && unreadCount > 0) {
                        _hasPlayedBellAnimation = true;
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setBool('hasPlayedBellAnimation', true);
                        });
                      }

                      final showLottie = unreadCount > 0 && !_hasPlayedBellAnimation == false;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () => context.go('/goals'),
                            icon: showLottie
                                ? Lottie.asset(
                              'assets/lottie/bell.json',
                              width: 36,
                              height: 36,
                              repeat: false,
                            )
                                : const Icon(Icons.notifications_none, color: Colors.black),
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                                child: Center(
                                  child: Text(
                                    unreadCount > 99 ? '99+' : '$unreadCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          // Showcase 덮기
                          Positioned.fill(
                            child: Showcase(
                              key: _notificationKey,
                              description: '확인하지 않은 목표가 있다면 알림을 줘요!',
                              descTextStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                              tooltipBackgroundColor: Colors.white,
                              overlayColor: Colors.black.withOpacity(0.7),
                              showArrow: false,
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: IndexedStack(
                index: widget.currentIndex,
                // children: _screens,
                children: [
                  HomeScreen(),
                  GoalWriteScreen(goal: widget.goal),
                  GoalListScreen(),
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
              onTap: (index) async {

                // 공통적으로 항상 invalidate
                ref.invalidate(homeProvider);

                final isChanged = ref.read(goalEditChangedProvider);

                if (widget.currentIndex == 1 && isChanged) {
                  final discard = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("저장되지 않은 내용이 있어요", style: TextStyle(fontSize: 20)),
                      content: const Text("저장하지 않으면 작성한 내용이 사라집니다."),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("취소")),
                        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("이동")),
                      ],
                    ),
                  );

                  if (discard != true) return;

                  ref.read(goalEditChangedProvider.notifier).state = false;
                  ref.read(resetGoalWriteProvider.notifier).state = true;
                }

                if (widget.currentIndex == 1) {
                  ref.read(goalEditChangedProvider.notifier).state = false;
                  ref.read(resetGoalWriteProvider.notifier).state = true;
                }

                switch (index) {
                  case 0:
                    ref.invalidate(homeProvider);
                    context.go('/home');
                    break;
                  case 1:
                    context.go('/write');
                    break;
                  case 2:
                    ref.invalidate(goalListProvider);
                    context.go('/goals');
                    break;
                  case 3:
                    ref.invalidate(myPageProvider);
                    context.go('/mypage');
                    break;
                }
              },
              items: [
                const BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
                BottomNavigationBarItem(
                  icon: Showcase(
                    key: _writeKey,
                    description: '여기서 나만의 목표를 작성할 수 있어요.',
                    descTextStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    tooltipBackgroundColor: Colors.white,
                    overlayColor: Colors.black.withOpacity(0.7),
                    targetPadding: const EdgeInsets.only(top: 7, bottom: 25, left: 18, right: 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.edit),
                        SizedBox(height: 4), // label 위치 보정용
                      ],
                    ),
                  ),
                  label: '목표 쓰기',
                ),
                BottomNavigationBarItem(
                  icon: Showcase(
                    key: _goalsKey,
                    description: '내가 작성한 목표를 한 눈에 확인할 수 있어요.',
                    descTextStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    tooltipBackgroundColor: Colors.white,
                    overlayColor: Colors.black.withOpacity(0.7),
                    targetPadding: const EdgeInsets.only(top: 9, bottom: 27, left: 18, right: 18),
                    child: const Icon(Icons.note_alt_rounded),
                  ),
                  label: '목표 리스트',
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
