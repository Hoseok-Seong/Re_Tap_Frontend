import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import '../dto/home/home_resp.dart';
import '../provider/home_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  String _formatFullDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool _refreshed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 화면 처음 들어올 때만 invalidate
    if (!_refreshed) {
      ref.invalidate(homeProvider);
      _refreshed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(homeProvider);

    return homeAsync.when(
      data: (home) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 16),
            _buildTodaySentence(home.todayQuote),
            const SizedBox(height: 16),
            _buildRecentLetter(context, home.recentLetters),
            const SizedBox(height: 16),
            _buildArrivalLetter(home.upcomingLetters),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('에러 발생: $err')),
    );
  }

  Widget _buildBanner() {
    final hashtags = [
      '#하루를 돌아보며',
      '#지금의 고민',
      '#이루고 싶은 목표',
      '#응원 한마디',
      '#나만의 다짐',
      '#사랑하는 사람에게'
    ];

    return _card(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.mail_outline, size: 40, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '시간을 담아, 나에게 보내는 편지',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  '오늘의 생각이, 언젠가의 나를 위로할지도 몰라요.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                _HashtagSwitcher(hashtags: hashtags),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySentence(Quote quote) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('오늘의 한 문장', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(quote.krContent, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text('- ${quote.author}', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTodayQuestion() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('오늘의 질문', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('오늘 하루 가장 기억에 남는 순간은 무엇인가요?', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildRecentLetter(BuildContext context, List<RecentLetter> letters) {
    final hasLetter = letters.isNotEmpty;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('최근 편지', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => context.go('/letters'),
                child: const Text('전체보기', style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          hasLetter
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: letters
                .take(3)
                .map(
                      (letter) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.mail, color: AppColors.primary, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${letter.title}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '작성일: ${_formatFullDate(letter.createdAt)}',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('아직 부친 편지가 없어요 🥲'),
                  GestureDetector(
                    onTap: () => context.go('/write'),
                    child: const Text(
                      '편지 쓰러가기 >',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildArrivalLetter(List<UpcomingLetter> upcomingLetters) {
    final count = upcomingLetters.length;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('도착 예정 편지', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          count == 0
              ? const Text('아직 도착한 편지가 없어요 📭')
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: upcomingLetters
                .take(3)
                .map(
                      (letter) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.lock, color: AppColors.primary, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  letter.title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '도착일: ${_formatFullDate(letter.arrivalDate)}',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child, EdgeInsetsGeometry padding = const EdgeInsets.all(20),}) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: child,
    );
  }
}

class _HashtagSwitcher extends StatefulWidget {
  final List<String> hashtags;
  const _HashtagSwitcher({required this.hashtags});

  @override
  State<_HashtagSwitcher> createState() => _HashtagSwitcherState();
}

class _HashtagSwitcherState extends State<_HashtagSwitcher> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startCycling();
  }

  void _startCycling() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.hashtags.length;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: Align(  // <- 왼쪽 정렬 고정
        alignment: Alignment.centerLeft,
        child: Text(
          widget.hashtags[_currentIndex],
          key: ValueKey(_currentIndex),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
