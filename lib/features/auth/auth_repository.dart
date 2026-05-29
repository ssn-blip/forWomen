import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'app_user.dart';

/// 인증 동작을 추상화한다.
///
/// 현재 구현([LocalAuthRepository])은 외부 비밀키 없이 동작하도록
/// 소셜 로그인을 "로컬 세션"으로 시뮬레이션한다. Naver/Google OAuth 키와
/// Firebase 설정이 준비되면 동일 인터페이스로 실제 구현을 추가하면 된다.
///
/// 실제 연동 지점:
///  - Google : `google_sign_in` + Firebase Auth credential
///  - Naver  : `flutter_naver_login` → Cloud Functions 커스텀 토큰 →
///             FirebaseAuth.signInWithCustomToken
abstract class AuthRepository {
  Future<AppUser?> currentUser();
  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithNaver();
  Future<void> signOut();
}

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'auth_user';
  static const _uuid = Uuid();

  @override
  Future<AppUser?> currentUser() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    return AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<AppUser> _persist(AppUser user) async {
    await _prefs.setString(_key, jsonEncode(user.toJson()));
    return user;
  }

  @override
  Future<AppUser> signInWithGoogle() {
    // TODO(auth): google_sign_in + Firebase 연동으로 교체.
    return _persist(AppUser(
      uid: 'google_${_uuid.v4()}',
      provider: 'google',
      displayName: '구글 사용자',
    ));
  }

  @override
  Future<AppUser> signInWithNaver() {
    // TODO(auth): flutter_naver_login + Cloud Functions 커스텀 토큰으로 교체.
    return _persist(AppUser(
      uid: 'naver_${_uuid.v4()}',
      provider: 'naver',
      displayName: '네이버 사용자',
    ));
  }

  @override
  Future<void> signOut() async {
    await _prefs.remove(_key);
  }
}
