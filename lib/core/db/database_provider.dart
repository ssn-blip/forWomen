import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';

/// 앱 전역에서 단일 [AppDatabase] 인스턴스를 공유한다.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
