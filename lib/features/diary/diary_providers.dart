import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';

/// 종류별 일기/메모 목록 (최신순). family로 kind 구분(메모는 별도 kind 사용).
final diaryProvider =
    StreamProvider.family<List<DiaryEntry>, String>((ref, kind) {
  return ref.watch(databaseProvider).watchDiary(kind);
});

/// 단일 일기 목록 (일반·과거 임신/육아일기 통합, 최신순).
final allDiaryProvider = StreamProvider<List<DiaryEntry>>((ref) {
  return ref.watch(databaseProvider).watchAllDiary();
});

/// 초음파 사진 목록 (최신순).
final ultrasoundProvider = StreamProvider<List<UltrasoundPhoto>>((ref) {
  return ref.watch(databaseProvider).watchUltrasounds();
});

/// 사진 경로 직렬화 도우미 (줄바꿈 구분).
List<String> decodePhotoPaths(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  return raw.split('\n').where((e) => e.isNotEmpty).toList();
}

String? encodePhotoPaths(List<String> paths) {
  if (paths.isEmpty) return null;
  return paths.join('\n');
}
