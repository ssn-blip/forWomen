import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_user.dart';
import 'auth_repository.dart';

/// SharedPreferences 인스턴스. main()에서 overrideWithValue로 주입한다.
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('main()에서 override 되어야 합니다.');
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return LocalAuthRepository(ref.watch(sharedPrefsProvider));
});

/// 현재 로그인 상태. 값이 null이면 비로그인.
class AuthController extends AsyncNotifier<AppUser?> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  FutureOr<AppUser?> build() => _repo.currentUser();

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repo.signInWithGoogle);
  }

  Future<void> signInWithNaver() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repo.signInWithNaver);
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AsyncValue.data(null);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AppUser?>(AuthController.new);
