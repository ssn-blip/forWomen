/// 로그인한 사용자 정보.
///
/// 현재는 로컬에 저장되는 경량 모델이다. 추후 Firebase Auth 연동 시
/// [uid]를 Firebase uid로 채우고 동일 모델을 그대로 사용한다.
class AppUser {
  const AppUser({
    required this.uid,
    required this.provider,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  final String uid;

  /// 'google' | 'naver' | 'local'
  final String provider;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'provider': provider,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        uid: json['uid'] as String,
        provider: json['provider'] as String,
        displayName: json['displayName'] as String?,
        email: json['email'] as String?,
        photoUrl: json['photoUrl'] as String?,
      );

  AppUser copyWith({String? displayName, String? email, String? photoUrl}) =>
      AppUser(
        uid: uid,
        provider: provider,
        displayName: displayName ?? this.displayName,
        email: email ?? this.email,
        photoUrl: photoUrl ?? this.photoUrl,
      );
}
