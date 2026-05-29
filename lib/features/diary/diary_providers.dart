import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';

/// 종류별 일기 목록 (최신순). family로 'pregnancy'/'parenting' 구분.
final diaryProvider =
    StreamProvider.family<List<DiaryEntry>, String>((ref, kind) {
  return ref.watch(databaseProvider).watchDiary(kind);
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
