import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final loading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const _Logo(),
              const SizedBox(height: 16),
              Text(
                '맘케어',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '생리·배란부터 임신·육아까지\n하나의 앱에서 기록하고 알림받으세요',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const Spacer(flex: 3),
              _SocialButton(
                label: 'Google로 시작하기',
                icon: Icons.g_mobiledata,
                background: Colors.white,
                foreground: const Color(0xFF4A4A4A),
                bordered: true,
                onPressed: loading
                    ? null
                    : () => ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle(),
              ),
              const SizedBox(height: 12),
              _SocialButton(
                label: 'Naver로 시작하기',
                icon: Icons.chat_bubble,
                background: const Color(0xFF03C75A),
                foreground: Colors.white,
                onPressed: loading
                    ? null
                    : () => ref
                        .read(authControllerProvider.notifier)
                        .signInWithNaver(),
              ),
              const SizedBox(height: 24),
              if (loading) const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                '* 현재는 데모 로그인입니다. 실제 소셜 로그인은\n키 발급 후 연동됩니다. (SETUP.md 참고)',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade400,
                    ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Icon(Icons.favorite, color: Colors.white, size: 48),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onPressed,
    this.bordered = false,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: foreground),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          side: bordered
              ? BorderSide(color: Colors.grey.shade300)
              : BorderSide.none,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
