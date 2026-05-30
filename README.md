# forWomen

생리·배란 주기 추적부터 임신 준비, 임신/출산 기록, 육아일기, 초음파·임테기 사진 보관,
약 복용·검진 알림, 시기별 정보 제공까지 — 여성 건강을 하나의 Flutter 앱에서 관리합니다.

## 기술 스택
- **Flutter** (Android 우선, iOS 추후)
- **Riverpod** 상태관리
- **Drift (SQLite)** 로컬 오프라인 DB
- **go_router** 네비게이션
- **flutter_local_notifications** 약·검진·일정 알림
- (예정) **Firebase** Auth/Firestore/Storage/FCM + 구글·네이버 소셜 로그인 → `SETUP.md` 참고

## 폴더 구조
```
lib/
  app.dart, main.dart
  core/
    db/            # Drift DB, 테이블, provider
    router/        # go_router + 하단 탭 셸
    theme/         # 파스텔 테마
    notifications/ # 로컬 알림 서비스
    utils/         # 날짜·주기·임신주차 계산 (date_calc.dart)
  features/
    auth/          # 로그인, 프로필 (현재 로컬 데모 인증)
    home/          # 대시보드
    cycle/         # 생리·배란 주기 (Phase 2)
    reminders/     # 알림 (Phase 3)
    ...            # pregnancy, diary, baby, info (이후 단계)
```

## 개발 단계 (Phases)
1. ✅ 기반 + 인증 토대
2. ✅ 생리·배란 주기 추적 (캘린더·예측·기록)
3. ✅ 임신 준비 + 임테기/배란테스트 + 알림 시스템
4. ✅ 임신 기록/관리 (주차·D-day·태아정보·체중·증상)
5. ✅ 일기 + 사진 갤러리 (임신/육아일기·초음파 앨범)
6. ✅ 출산·육아 기록 (수유·기저귀·예방접종)
7. ✅ 정보 콘텐츠 + 동기화 토대 (`synced` 플래그)

> 클라우드 동기화·소셜 로그인 실연동은 Firebase/Naver 키 발급 후 진행합니다 → `SETUP.md`

## 실행
```powershell
flutter pub get
dart run build_runner build   # DB 스키마 변경 시마다
flutter run
flutter test
```

> ⚠️ 의료 면책: 주기 예측·임테기 판독 등은 참고용이며 의료 진단이 아닙니다.
