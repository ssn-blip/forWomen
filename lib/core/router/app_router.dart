import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/profile_screen.dart';
import '../../features/baby/baby_screen.dart';
import '../../features/conception/conception_screen.dart';
import '../../features/cycle/cycle_screen.dart';
import '../../features/diary/diary_screen.dart';
import '../../features/diary/ultrasound_gallery_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/info/info_screen.dart';
import '../../features/pregnancy/pregnancy_screen.dart';
import '../../features/reminders/reminders_screen.dart';
import 'main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      // 인증 상태 로딩 중에는 리다이렉트 보류.
      if (auth.isLoading) return null;
      final loggedIn = auth.value != null;
      final onLogin = state.matchedLocation == '/login';

      if (!loggedIn) return onLogin ? null : '/login';
      if (onLogin) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/conception',
        builder: (context, state) => const ConceptionScreen(),
      ),
      GoRoute(
        path: '/pregnancy',
        builder: (context, state) => const PregnancyScreen(),
      ),
      GoRoute(
        path: '/diary',
        builder: (context, state) => const DiaryScreen(),
      ),
      GoRoute(
        path: '/ultrasound',
        builder: (context, state) => const UltrasoundGalleryScreen(),
      ),
      GoRoute(
        path: '/baby',
        builder: (context, state) => const BabyScreen(),
      ),
      GoRoute(
        path: '/info',
        builder: (context, state) => const InfoScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/cycle',
              builder: (context, state) => const CycleScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/reminders',
              builder: (context, state) => const RemindersScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});
