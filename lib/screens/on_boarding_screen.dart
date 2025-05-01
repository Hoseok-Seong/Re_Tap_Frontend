import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../common/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 1.0,
  );

  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': '미래의 나에게\n편지를 남겨보세요',
      'subtitle': '언제든 꺼내볼 수 있어요',
    },
    {
      'title': '아무도 모르게\n나만 볼 수 있어요',
      'subtitle': '안전하게 보관됩니다',
    },
    {
      'title': '그럼, 시작해볼까요?',
      'subtitle': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ClipRect(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SizedBox.expand(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _pages[index]['title']!,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _pages[index]['subtitle']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: WormEffect(
                  dotColor: Colors.grey.shade300,
                  activeDotColor: AppColors.primary,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _currentPage == _pages.length - 1
                      ? () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isFirstLaunch', false);
                    if (context.mounted) {
                      context.go('/login');
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentPage == _pages.length - 1
                        ? AppColors.primary
                        : Colors.grey.shade300,
                  ),
                  child: const Text('시작하기'),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
