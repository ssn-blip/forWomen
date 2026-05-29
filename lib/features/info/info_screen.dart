import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_calc.dart';
import '../baby/baby_providers.dart';
import '../pregnancy/pregnancy_providers.dart';
import 'info_content.dart';

class InfoScreen extends ConsumerWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('정보'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '임신준비'),
              Tab(text: '임신'),
              Tab(text: '육아'),
            ],
          ),
        ),
        body: Column(
          children: [
            const _ContextBanner(),
            const Expanded(
              child: TabBarView(
                children: [
                  _ArticleList(category: 'conception'),
                  _ArticleList(category: 'pregnancy'),
                  _ArticleList(category: 'parenting'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 현재 임신/육아 상태에 맞춘 한 줄 안내.
class _ContextBanner extends ConsumerWidget {
  const _ContextBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preg = ref.watch(activePregnancyProvider).value;
    final baby = ref.watch(activeBabyProvider);
    final now = DateCalc.dateOnly(DateTime.now());

    String message;
    if (preg != null) {
      final age = DateCalc.gestationalAge(preg.lastPeriodStart, now);
      final trimester = age.week < 14 ? '1분기' : (age.week < 28 ? '2분기' : '3분기');
      message = '임신 ${age.week}주차예요. "임신" 탭의 $trimester 정보를 확인해 보세요.';
    } else if (baby != null) {
      final months = DateCalc.daysBetween(baby.birthDate, now) ~/ 30;
      message = '${baby.name} 생후 $months개월. "육아" 탭에서 도움말을 확인하세요.';
    } else {
      message = '임신을 준비 중이신가요? "임신준비" 탭의 정보를 살펴보세요.';
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: AppTheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

class _ArticleList extends StatelessWidget {
  const _ArticleList({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final articles = articlesByCategory(category);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      itemCount: articles.length + 1,
      itemBuilder: (context, i) {
        if (i == articles.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '※ 위 정보는 일반적인 참고 자료이며, 개인의 상태에 대한 판단은 '
              '반드시 의료진과 상담하세요.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        }
        final a = articles[i];
        return Card(
          child: ExpansionTile(
            shape: const Border(),
            leading: const Icon(Icons.article_outlined,
                color: AppTheme.secondary),
            title: Text(a.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            childrenPadding:
                const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(a.body,
                    style: TextStyle(
                        color: Colors.grey.shade800, height: 1.5)),
              ),
            ],
          ),
        );
      },
    );
  }
}
