import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/auth_controller.dart';
import '../db/database.dart';
import '../db/database_provider.dart';

/// 모든 로컬 데이터(기록 + 설정)를 JSON으로 내보내고 복원한다.
/// 클라우드 동기화 전, 기기 변경/백업 대비 수동 백업 용도.
/// (사진 파일은 경로만 포함되며 이미지 자체는 백업되지 않음)
class BackupService {
  BackupService(this._db, this._prefs);

  final AppDatabase _db;
  final SharedPreferences _prefs;

  static const _prefKeys = [
    'cycle_avg_length',
    'cycle_period_length',
    'cycle_auto_learn',
    'pill_enabled',
    'pill_start',
    'pill_count',
    'pill_break',
  ];

  /// 전체 데이터를 보기 좋은 JSON 문자열로 직렬화.
  Future<String> exportJson() async {
    final tables = <String, dynamic>{};
    for (final t in _db.allTables) {
      final rows = await _db.select(t).get();
      tables[t.actualTableName] =
          rows.map((r) => (r as DataClass).toJson()).toList();
    }

    final prefs = <String, dynamic>{};
    for (final k in _prefKeys) {
      final v = _prefs.get(k);
      if (v != null) prefs[k] = v;
    }

    return const JsonEncoder.withIndent('  ').convert({
      'app': 'momcare',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'tables': tables,
      'prefs': prefs,
    });
  }

  /// JSON 백업을 읽어 기존 데이터를 대체(복원)한다.
  Future<void> importJson(String jsonStr) async {
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    if (data['app'] != 'momcare') {
      throw const FormatException('맘케어 백업 파일이 아닙니다.');
    }
    final tables = (data['tables'] as Map).cast<String, dynamic>();

    for (final entry in _importers().entries) {
      final rows = tables[entry.key];
      if (rows is List) await entry.value(rows);
    }

    final prefs = data['prefs'];
    if (prefs is Map) {
      for (final e in prefs.entries) {
        final k = e.key as String;
        final v = e.value;
        if (v is bool) {
          await _prefs.setBool(k, v);
        } else if (v is int) {
          await _prefs.setInt(k, v);
        } else if (v is double) {
          await _prefs.setDouble(k, v);
        } else if (v is String) {
          await _prefs.setString(k, v);
        }
      }
    }
  }

  Map<String, Future<void> Function(List<dynamic>)> _importers() => {
        _db.cycleLogs.actualTableName: (r) =>
            _restore(_db.cycleLogs, r, CycleLog.fromJson),
        _db.bbtLogs.actualTableName: (r) =>
            _restore(_db.bbtLogs, r, BbtLog.fromJson),
        _db.testLogs.actualTableName: (r) =>
            _restore(_db.testLogs, r, TestLog.fromJson),
        _db.pregnancies.actualTableName: (r) =>
            _restore(_db.pregnancies, r, Pregnancy.fromJson),
        _db.reminders.actualTableName: (r) =>
            _restore(_db.reminders, r, Reminder.fromJson),
        _db.weightLogs.actualTableName: (r) =>
            _restore(_db.weightLogs, r, WeightLog.fromJson),
        _db.symptomLogs.actualTableName: (r) =>
            _restore(_db.symptomLogs, r, SymptomLog.fromJson),
        _db.diaryEntries.actualTableName: (r) =>
            _restore(_db.diaryEntries, r, DiaryEntry.fromJson),
        _db.ultrasoundPhotos.actualTableName: (r) =>
            _restore(_db.ultrasoundPhotos, r, UltrasoundPhoto.fromJson),
        _db.babyProfiles.actualTableName: (r) =>
            _restore(_db.babyProfiles, r, BabyProfile.fromJson),
        _db.feedingLogs.actualTableName: (r) =>
            _restore(_db.feedingLogs, r, FeedingLog.fromJson),
        _db.diaperLogs.actualTableName: (r) =>
            _restore(_db.diaperLogs, r, DiaperLog.fromJson),
        _db.vaccinationRecords.actualTableName: (r) =>
            _restore(_db.vaccinationRecords, r, VaccinationRecord.fromJson),
        _db.dayEvents.actualTableName: (r) =>
            _restore(_db.dayEvents, r, DayEvent.fromJson),
      };

  /// 테이블을 비우고 백업 행들을 다시 채운다(id 유지).
  Future<void> _restore<T extends Table, D>(
    TableInfo<T, D> table,
    List<dynamic> rows,
    Insertable<D> Function(Map<String, dynamic>) fromJson,
  ) async {
    await _db.delete(table).go();
    await _db.batch((b) {
      for (final r in rows) {
        b.insert(
          table,
          fromJson((r as Map).cast<String, dynamic>()),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    ref.watch(databaseProvider),
    ref.watch(sharedPrefsProvider),
  );
});
