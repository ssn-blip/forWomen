import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// ─────────────────────────────────────────────────────────────────────────
// 테이블 정의
// 모든 레코드는 [synced] 플래그를 가져 추후 Firestore 동기화에 사용한다.
// ─────────────────────────────────────────────────────────────────────────

/// 생리 기록
class CycleLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();

  /// 출혈량 1(적음)~3(많음)
  IntColumn get flow => integer().nullable()();

  /// 증상/메모 (쉼표 구분 태그 + 자유 메모)
  TextColumn get symptoms => text().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 기초체온 기록 (배란 추정용)
class BbtLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get temperature => real()();
  TextColumn get note => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 임테기/배란테스트 기록
class TestLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();

  /// 'pregnancy'(임신테스트) | 'ovulation'(배란테스트)
  TextColumn get kind => text()();

  /// 'positive' | 'negative' | 'faint'(희미) | 'unknown'
  TextColumn get result => text()();

  /// 촬영(또는 크롭) 사진 로컬 경로
  TextColumn get photoPath => text().nullable()();

  /// 자동 분석 진하기 비율 T/C (0~1+, 사진 분석 시). 없으면 수동 입력.
  RealColumn get ratio => real().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 임신 정보
class Pregnancies extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// 마지막 생리 시작일 (주차/출산예정일 계산 기준)
  DateTimeColumn get lastPeriodStart => dateTime()();

  /// 사용자가 직접 지정한 출산 예정일 (없으면 LMP+280일 사용)
  DateTimeColumn get dueDateOverride => dateTime().nullable()();

  /// 'active'(진행) | 'completed'(출산) | 'ended'(종료)
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get note => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 알림 (약 복용 / 검진 / 일정)
class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// 'medication'(약) | 'checkup'(검진) | 'custom'(일정)
  TextColumn get kind => text()();
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();

  /// 다음 알림 시각
  DateTimeColumn get nextTrigger => dateTime()();

  /// 반복 규칙: 'none' | 'daily' | 'weekly'
  TextColumn get repeat => text().withDefault(const Constant('none'))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 임신 중 체중 기록
class WeightLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get weightKg => real()();
  TextColumn get note => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 임신 중 증상 기록
class SymptomLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();

  /// 쉼표 구분 증상 태그
  TextColumn get symptoms => text()();

  /// 강도 1(약)~3(심)
  IntColumn get severity => integer().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 일기 (임신일기 / 육아일기)
class DiaryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();

  /// 'pregnancy'(임신일기) | 'parenting'(육아일기)
  TextColumn get kind => text()();
  TextColumn get title => text().nullable()();
  TextColumn get body => text()();

  /// 기분 1(나쁨)~5(좋음)
  IntColumn get mood => integer().nullable()();

  /// 첨부 사진 경로들 (줄바꿈 구분). 경로엔 줄바꿈이 없어 안전하다.
  TextColumn get photoPaths => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 초음파 사진
class UltrasoundPhotos extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get takenAt => dateTime()();

  /// 촬영 시점 임신 주차
  IntColumn get week => integer().nullable()();
  TextColumn get path => text()();
  TextColumn get note => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 아기 프로필
class BabyProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get birthDate => dateTime()();

  /// 'male' | 'female' | null
  TextColumn get gender => text().nullable()();
  TextColumn get photoPath => text().nullable()();

  /// 출생 체중(kg) — 출산 기록 시 입력
  RealColumn get birthWeightKg => real().nullable()();

  /// 분만 방법 등 출산 메모
  TextColumn get birthNote => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 수유 기록
class FeedingLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get babyId => integer()();
  DateTimeColumn get time => dateTime()();

  /// 'breast'(모유) | 'bottle'(분유) | 'solid'(이유식)
  TextColumn get type => text()();
  IntColumn get amountMl => integer().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 기저귀 기록
class DiaperLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get babyId => integer()();
  DateTimeColumn get time => dateTime()();

  /// 'wet'(소변) | 'dirty'(대변) | 'both'
  TextColumn get type => text()();
  TextColumn get note => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 육아 성장 사진 + 메모
class BabyPhotos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get babyId => integer()();
  DateTimeColumn get takenAt => dateTime()();
  TextColumn get path => text()();
  TextColumn get note => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 예방접종 완료 기록 (완료한 항목만 저장)
class VaccinationRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get babyId => integer()();
  TextColumn get name => text()();
  DateTimeColumn get doneDate => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 캘린더에 아이콘으로 표시되는 범용 일자 기록.
/// 배란·약복용·주사·병원·임신 등 종류별 기록을 한 테이블에서 관리한다.
/// (생리는 출혈량/증상 등 고유 필드가 있어 CycleLogs로 별도 관리)
class DayEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();

  /// 'ovulation'(배란) | 'medication'(약) | 'injection'(주사)
  /// | 'hospital'(병원) | 'pregnancy'(임신)
  TextColumn get type => text()();
  TextColumn get title => text().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 주기 화면의 날짜별 증상 태그 (칩 선택). 임신 중 SymptomLogs와 별개로
/// 생리/배란 주기 트래킹용 증상을 날짜 1건으로 관리한다.
class DaySymptoms extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();

  /// 쉼표 구분 증상 태그
  TextColumn get symptoms => text()();
  TextColumn get note => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// 하루 노트 (날씨 + 기분 + 메모). 날짜 1건.
class DayNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();

  /// 'sunny' | 'cloudy' | 'rainy' | 'snowy' 등
  TextColumn get weather => text().nullable()();

  /// 기분 1(나쁨)~5(좋음)
  IntColumn get mood => integer().nullable()();
  TextColumn get memo => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

// ─────────────────────────────────────────────────────────────────────────
// 데이터베이스
// ─────────────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [
  CycleLogs,
  BbtLogs,
  TestLogs,
  Pregnancies,
  Reminders,
  WeightLogs,
  SymptomLogs,
  DiaryEntries,
  UltrasoundPhotos,
  BabyProfiles,
  FeedingLogs,
  DiaperLogs,
  VaccinationRecords,
  BabyPhotos,
  DayEvents,
  DaySymptoms,
  DayNotes,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// 테스트용: 인메모리 DB 주입
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(weightLogs);
            await m.createTable(symptomLogs);
          }
          if (from < 3) {
            await m.createTable(diaryEntries);
            await m.createTable(ultrasoundPhotos);
          }
          if (from < 4) {
            await m.createTable(babyProfiles);
            await m.createTable(feedingLogs);
            await m.createTable(diaperLogs);
            await m.createTable(vaccinationRecords);
          }
          if (from < 5) {
            await m.addColumn(babyProfiles, babyProfiles.birthWeightKg);
            await m.addColumn(babyProfiles, babyProfiles.birthNote);
          }
          if (from < 6) {
            await m.createTable(dayEvents);
          }
          if (from < 7) {
            await m.addColumn(testLogs, testLogs.ratio);
          }
          if (from < 8) {
            await m.createTable(babyPhotos);
          }
          if (from < 9) {
            await m.createTable(daySymptoms);
          }
          if (from < 10) {
            await m.createTable(dayNotes);
          }
        },
      );

  // ── 생리 기록 ────────────────────────────────────────────────────────
  Future<List<CycleLog>> allCycleLogs() =>
      (select(cycleLogs)..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();

  Stream<List<CycleLog>> watchCycleLogs() =>
      (select(cycleLogs)..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .watch();

  Future<int> insertCycleLog(CycleLogsCompanion entry) =>
      into(cycleLogs).insert(entry);

  Future<bool> updateCycleLog(CycleLog entry) =>
      update(cycleLogs).replace(entry);

  Future<int> deleteCycleLog(int id) =>
      (delete(cycleLogs)..where((t) => t.id.equals(id))).go();

  // ── 기초체온 ────────────────────────────────────────────────────────
  Stream<List<BbtLog>> watchBbtLogs() =>
      (select(bbtLogs)..orderBy([(t) => OrderingTerm.asc(t.date)])).watch();

  Future<int> insertBbtLog(BbtLogsCompanion entry) =>
      into(bbtLogs).insert(entry);

  Future<bool> updateBbtLog(BbtLog entry) =>
      update(bbtLogs).replace(entry);

  Future<int> deleteBbtLog(int id) =>
      (delete(bbtLogs)..where((t) => t.id.equals(id))).go();

  // ── 임테기/배란테스트 ────────────────────────────────────────────────
  Stream<List<TestLog>> watchTestLogs() =>
      (select(testLogs)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  Future<int> insertTestLog(TestLogsCompanion entry) =>
      into(testLogs).insert(entry);

  Future<int> deleteTestLog(int id) =>
      (delete(testLogs)..where((t) => t.id.equals(id))).go();

  // ── 임신 ────────────────────────────────────────────────────────────
  // 활성 임신이 2개 이상이어도 안전하도록 최신 1건만 가져온다.
  Future<Pregnancy?> activePregnancy() => (select(pregnancies)
        ..where((t) => t.status.equals('active'))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
        ..limit(1))
      .getSingleOrNull();

  Stream<Pregnancy?> watchActivePregnancy() => (select(pregnancies)
        ..where((t) => t.status.equals('active'))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
        ..limit(1))
      .watchSingleOrNull();

  Future<int> insertPregnancy(PregnanciesCompanion entry) =>
      into(pregnancies).insert(entry);

  Future<bool> updatePregnancy(Pregnancy entry) =>
      update(pregnancies).replace(entry);

  /// 진행 중인 모든 임신을 종료 처리(중복 활성 방지).
  Future<int> endActivePregnancies() => (update(pregnancies)
        ..where((t) => t.status.equals('active')))
      .write(const PregnanciesCompanion(status: Value('ended')));

  Future<int> deletePregnancy(int id) =>
      (delete(pregnancies)..where((t) => t.id.equals(id))).go();

  // ── 알림 ────────────────────────────────────────────────────────────
  Stream<List<Reminder>> watchReminders() =>
      (select(reminders)..orderBy([(t) => OrderingTerm.asc(t.nextTrigger)]))
          .watch();

  Future<List<Reminder>> allReminders() =>
      (select(reminders)..orderBy([(t) => OrderingTerm.asc(t.nextTrigger)]))
          .get();

  Future<int> insertReminder(RemindersCompanion entry) =>
      into(reminders).insert(entry);

  Future<bool> updateReminder(Reminder entry) =>
      update(reminders).replace(entry);

  Future<int> deleteReminder(int id) =>
      (delete(reminders)..where((t) => t.id.equals(id))).go();

  // ── 체중 ────────────────────────────────────────────────────────────
  Stream<List<WeightLog>> watchWeightLogs() =>
      (select(weightLogs)..orderBy([(t) => OrderingTerm.asc(t.date)])).watch();

  Future<int> insertWeightLog(WeightLogsCompanion entry) =>
      into(weightLogs).insert(entry);

  Future<int> deleteWeightLog(int id) =>
      (delete(weightLogs)..where((t) => t.id.equals(id))).go();

  // ── 증상 ────────────────────────────────────────────────────────────
  Stream<List<SymptomLog>> watchSymptomLogs() =>
      (select(symptomLogs)..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  Future<int> insertSymptomLog(SymptomLogsCompanion entry) =>
      into(symptomLogs).insert(entry);

  Future<int> deleteSymptomLog(int id) =>
      (delete(symptomLogs)..where((t) => t.id.equals(id))).go();

  // ── 일기 ────────────────────────────────────────────────────────────
  Stream<List<DiaryEntry>> watchDiary(String kind) =>
      (select(diaryEntries)
            ..where((t) => t.kind.equals(kind))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  Future<int> insertDiary(DiaryEntriesCompanion entry) =>
      into(diaryEntries).insert(entry);

  Future<bool> updateDiary(DiaryEntry entry) =>
      update(diaryEntries).replace(entry);

  Future<int> deleteDiary(int id) =>
      (delete(diaryEntries)..where((t) => t.id.equals(id))).go();

  // ── 초음파 사진 ─────────────────────────────────────────────────────
  Stream<List<UltrasoundPhoto>> watchUltrasounds() =>
      (select(ultrasoundPhotos)..orderBy([(t) => OrderingTerm.desc(t.takenAt)]))
          .watch();

  Future<int> insertUltrasound(UltrasoundPhotosCompanion entry) =>
      into(ultrasoundPhotos).insert(entry);

  Future<int> deleteUltrasound(int id) =>
      (delete(ultrasoundPhotos)..where((t) => t.id.equals(id))).go();

  /// 초음파 사진 메모 수정
  Future<int> updateUltrasoundNote(int id, String? note) =>
      (update(ultrasoundPhotos)..where((t) => t.id.equals(id)))
          .write(UltrasoundPhotosCompanion(note: Value(note)));

  // ── 아기 프로필 ─────────────────────────────────────────────────────
  Stream<List<BabyProfile>> watchBabies() =>
      (select(babyProfiles)..orderBy([(t) => OrderingTerm.asc(t.birthDate)]))
          .watch();

  Future<int> insertBaby(BabyProfilesCompanion entry) =>
      into(babyProfiles).insert(entry);

  Future<int> deleteBaby(int id) =>
      (delete(babyProfiles)..where((t) => t.id.equals(id))).go();

  // ── 수유 ────────────────────────────────────────────────────────────
  Stream<List<FeedingLog>> watchFeedings(int babyId) =>
      (select(feedingLogs)
            ..where((t) => t.babyId.equals(babyId))
            ..orderBy([(t) => OrderingTerm.desc(t.time)]))
          .watch();

  Future<int> insertFeeding(FeedingLogsCompanion entry) =>
      into(feedingLogs).insert(entry);

  Future<int> deleteFeeding(int id) =>
      (delete(feedingLogs)..where((t) => t.id.equals(id))).go();

  // ── 기저귀 ──────────────────────────────────────────────────────────
  Stream<List<DiaperLog>> watchDiapers(int babyId) =>
      (select(diaperLogs)
            ..where((t) => t.babyId.equals(babyId))
            ..orderBy([(t) => OrderingTerm.desc(t.time)]))
          .watch();

  Future<int> insertDiaper(DiaperLogsCompanion entry) =>
      into(diaperLogs).insert(entry);

  Future<int> deleteDiaper(int id) =>
      (delete(diaperLogs)..where((t) => t.id.equals(id))).go();

  // ── 예방접종 ────────────────────────────────────────────────────────
  Stream<List<VaccinationRecord>> watchVaccinations(int babyId) =>
      (select(vaccinationRecords)..where((t) => t.babyId.equals(babyId)))
          .watch();

  Future<int> insertVaccination(VaccinationRecordsCompanion entry) =>
      into(vaccinationRecords).insert(entry);

  Future<int> deleteVaccinationByName(int babyId, String name) =>
      (delete(vaccinationRecords)
            ..where((t) => t.babyId.equals(babyId) & t.name.equals(name)))
          .go();

  // ── 육아 성장 사진 ───────────────────────────────────────────────────
  Stream<List<BabyPhoto>> watchBabyPhotos(int babyId) =>
      (select(babyPhotos)
            ..where((t) => t.babyId.equals(babyId))
            ..orderBy([(t) => OrderingTerm.desc(t.takenAt)]))
          .watch();

  Future<int> insertBabyPhoto(BabyPhotosCompanion entry) =>
      into(babyPhotos).insert(entry);

  Future<int> deleteBabyPhoto(int id) =>
      (delete(babyPhotos)..where((t) => t.id.equals(id))).go();

  Future<int> updateBabyPhotoNote(int id, String? note) =>
      (update(babyPhotos)..where((t) => t.id.equals(id)))
          .write(BabyPhotosCompanion(note: Value(note)));

  // ── 캘린더 이벤트 (배란/약/주사/병원/임신) ──────────────────────────
  Stream<List<DayEvent>> watchDayEvents() =>
      (select(dayEvents)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  Future<int> insertDayEvent(DayEventsCompanion entry) =>
      into(dayEvents).insert(entry);

  Future<bool> updateDayEvent(DayEvent entry) =>
      update(dayEvents).replace(entry);

  Future<int> deleteDayEvent(int id) =>
      (delete(dayEvents)..where((t) => t.id.equals(id))).go();

  /// 특정 종류의 이벤트를 모두 삭제 (예: 피임약 자동 재생성 전 초기화).
  Future<int> deleteEventsOfType(String type) =>
      (delete(dayEvents)..where((t) => t.type.equals(type))).go();

  /// 특정 종류의 이벤트를 날짜 범위(포함)로 삭제 (예: 피임약 이번 판만).
  Future<int> deleteEventsOfTypeInRange(
          String type, DateTime start, DateTime end) =>
      (delete(dayEvents)
            ..where((t) =>
                t.type.equals(type) & t.date.isBetweenValues(start, end)))
          .go();

  // ── 날짜별 증상 태그(주기 칩 선택) ─────────────────────────────────────
  Stream<List<DaySymptom>> watchDaySymptoms() =>
      (select(daySymptoms)..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  /// 특정 날짜의 증상 기록 1건(없으면 null).
  Future<DaySymptom?> getDaySymptom(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(daySymptoms)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..limit(1))
        .getSingleOrNull();
  }

  /// 날짜의 증상을 저장(빈 값이면 삭제). 기존 1건을 갱신, 없으면 추가.
  Future<void> setDaySymptoms(DateTime day, String csv, {String? note}) async {
    final existing = await getDaySymptom(day);
    if (csv.trim().isEmpty) {
      if (existing != null) await deleteDaySymptom(existing.id);
      return;
    }
    if (existing != null) {
      await (update(daySymptoms)..where((t) => t.id.equals(existing.id)))
          .write(DaySymptomsCompanion(
              symptoms: Value(csv), note: Value(note)));
    } else {
      await into(daySymptoms).insert(DaySymptomsCompanion(
          date: Value(day), symptoms: Value(csv), note: Value(note)));
    }
  }

  Future<int> deleteDaySymptom(int id) =>
      (delete(daySymptoms)..where((t) => t.id.equals(id))).go();

  // ── 예방접종 전체(모아보기용) ──────────────────────────────────────────
  Stream<List<VaccinationRecord>> watchAllVaccinations() =>
      (select(vaccinationRecords)
            ..orderBy([(t) => OrderingTerm.desc(t.doneDate)]))
          .watch();

  // ── 하루 노트(날씨·기분·메모) ─────────────────────────────────────────
  Stream<List<DayNote>> watchDayNotes() =>
      (select(dayNotes)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  Future<DayNote?> getDayNote(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(dayNotes)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..limit(1))
        .getSingleOrNull();
  }

  /// 노트 저장(모두 비면 삭제). 기존 1건 갱신, 없으면 추가.
  Future<void> setDayNote(DateTime day,
      {String? weather, int? mood, String? memo}) async {
    final existing = await getDayNote(day);
    final empty = (weather == null) &&
        (mood == null) &&
        (memo == null || memo.trim().isEmpty);
    if (empty) {
      if (existing != null) await deleteDayNote(existing.id);
      return;
    }
    final companion = DayNotesCompanion(
      weather: Value(weather),
      mood: Value(mood),
      memo: Value(memo == null || memo.trim().isEmpty ? null : memo.trim()),
    );
    if (existing != null) {
      await (update(dayNotes)..where((t) => t.id.equals(existing.id)))
          .write(companion);
    } else {
      await into(dayNotes).insert(DayNotesCompanion(
        date: Value(day),
        weather: Value(weather),
        mood: Value(mood),
        memo: Value(memo == null || memo.trim().isEmpty ? null : memo.trim()),
      ));
    }
  }

  Future<int> deleteDayNote(int id) =>
      (delete(dayNotes)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'forwomen.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
