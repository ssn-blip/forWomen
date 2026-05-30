# forWomen — 설정 가이드 (소셜 로그인 · Firebase 연동)

현재 앱은 **외부 비밀키 없이 바로 실행**되도록 만들어져 있습니다.
로그인 버튼은 "데모 로그인"으로 동작하며, 아래 절차를 마치면 **실제 구글/네이버 로그인**과
**클라우드 동기화/푸시 알림**이 활성화됩니다. (각 단계는 사용자 계정·키가 필요합니다.)

---

## 1. Firebase 프로젝트 (구글 로그인 · 동기화 · 푸시 기반)

1. <https://console.firebase.google.com> 에서 프로젝트 생성
2. Android 앱 등록
   - 패키지명: `com.forwomen.forwomen`
   - 디버그 SHA-1 등록:
     ```powershell
     cd android; ./gradlew signingReport
     ```
     출력의 `SHA1` 값을 Firebase 콘솔에 등록
3. `google-services.json` 다운로드 → `android/app/` 에 복사
4. CLI 연동:
   ```powershell
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   → `lib/firebase_options.dart` 자동 생성
5. 패키지 추가:
   ```powershell
   flutter pub add firebase_core firebase_auth cloud_firestore firebase_storage firebase_messaging google_sign_in
   ```
6. `android/app/build.gradle.kts` 의 `plugins {}` 에 추가:
   ```kotlin
   id("com.google.gms.google-services")
   ```
   그리고 `android/settings.gradle.kts` 의 plugins 블록에:
   ```kotlin
   id("com.google.gms.google-services") version "4.4.2" apply false
   ```

## 2. 네이버 로그인

1. <https://developers.naver.com/apps> 에서 애플리케이션 등록
   - 사용 API: 네이버 로그인
   - Android 패키지명: `com.forwomen.forwomen`
   - **Client ID / Client Secret** 발급
2. 패키지 추가: `flutter pub add flutter_naver_login`
3. 네이버는 Firebase Auth가 기본 지원하지 않으므로 **커스텀 토큰** 방식 사용:
   - Cloud Functions(`firebase/functions`)에서 네이버 액세스 토큰을 검증하고
     `admin.auth().createCustomToken(uid)` 로 Firebase 커스텀 토큰 발급
   - 앱에서 `FirebaseAuth.instance.signInWithCustomToken(token)` 호출

## 3. 코드 연동 지점

`lib/features/auth/auth_repository.dart` 의 `LocalAuthRepository` 를 대체할
`FirebaseAuthRepository` 를 만들고 `signInWithGoogle()` / `signInWithNaver()` 를 실제 구현으로
교체한 뒤, `auth_controller.dart` 의 `authRepositoryProvider` 가 새 구현을 반환하도록 바꾸면 됩니다.
(`AuthRepository` 인터페이스는 그대로 유지되어 화면 코드는 수정 불필요)

## 4. iOS 빌드

현재 개발 환경(Windows)에서는 iOS 빌드가 불가합니다.
Mac 또는 Codemagic/Bitrise 등 클라우드 Mac 빌드에서 진행하세요.

---

## 실행 방법 (현재 상태)

```powershell
flutter pub get
dart run build_runner build   # Drift 코드 생성 (DB 스키마 변경 시마다)
flutter run                   # 에뮬레이터 또는 연결된 기기
flutter test                  # 단위 테스트
```
