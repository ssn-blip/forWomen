import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../cycle/cycle_settings_dialog.dart';
import 'auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final providerLabel = switch (user?.provider) {
      'google' => 'Google 계정',
      'naver' => 'Naver 계정',
      _ => '로컬 계정',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('내 정보')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
              child: const Icon(Icons.person, size: 48, color: AppTheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              user?.displayName ?? '회원',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(providerLabel,
                style: TextStyle(color: Colors.grey.shade600)),
          ),
          const SizedBox(height: 24),
          _SectionTile(
            icon: Icons.settings,
            title: '주기 설정 (평균 주기·생리기간)',
            onTap: () => CycleSettingsDialog.show(context),
          ),
          _SectionTile(
            icon: Icons.notifications,
            title: '알림 설정',
            onTap: () => context.go('/reminders'),
          ),
          _SectionTile(
            icon: Icons.insights,
            title: '기록 통계',
            onTap: () => context.push('/stats'),
          ),
          _SectionTile(
            icon: Icons.cloud_sync,
            title: '백업·동기화',
            onTap: () => context.push('/backup'),
          ),
          _SectionTile(
            icon: Icons.privacy_tip,
            title: '개인정보·의료 면책',
            onTap: () => _showInfoDialog(
              context,
              '개인정보·의료 면책',
              '• 입력하신 건강 정보는 기기 내부에만 저장되며 외부로 전송되지 않습니다.\n\n'
                  '• 이 앱의 주기 예측, 임테기 판독 가이드, 시기별 정보 등은 일반적인 '
                  '참고 자료이며 의료 진단을 대체하지 않습니다.\n\n'
                  '• 건강과 관련된 결정은 반드시 의료 전문가와 상담하세요.',
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
            label: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}

void _showInfoDialog(BuildContext context, String title, String body) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: Text(body)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('확인')),
      ],
    ),
  );
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({required this.icon, required this.title, this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppTheme.secondary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap ??
            () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('다음 단계에서 추가됩니다')),
                ),
      ),
    );
  }
}
