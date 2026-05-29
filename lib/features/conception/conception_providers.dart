import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';

/// 임테기/배란테스트 기록 (최신순).
final testLogsProvider = StreamProvider<List<TestLog>>((ref) {
  return ref.watch(databaseProvider).watchTestLogs();
});

/// 기초체온 기록 (날짜 오름차순 — 그래프용).
final bbtLogsProvider = StreamProvider<List<BbtLog>>((ref) {
  return ref.watch(databaseProvider).watchBbtLogs();
});
