import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';

/// 등록된 아기 목록.
final babiesProvider = StreamProvider<List<BabyProfile>>((ref) {
  return ref.watch(databaseProvider).watchBabies();
});

/// 현재 선택된(첫 번째) 아기.
final activeBabyProvider = Provider<BabyProfile?>((ref) {
  final babies = ref.watch(babiesProvider).value ?? const [];
  return babies.isEmpty ? null : babies.first;
});

/// 특정 아기의 수유 기록.
final feedingsProvider =
    StreamProvider.family<List<FeedingLog>, int>((ref, babyId) {
  return ref.watch(databaseProvider).watchFeedings(babyId);
});

/// 특정 아기의 기저귀 기록.
final diapersProvider =
    StreamProvider.family<List<DiaperLog>, int>((ref, babyId) {
  return ref.watch(databaseProvider).watchDiapers(babyId);
});

/// 모든 아기의 예방접종 완료 기록(모아보기용, 최신순).
final allVaccinationsProvider =
    StreamProvider<List<VaccinationRecord>>((ref) {
  return ref.watch(databaseProvider).watchAllVaccinations();
});

/// 특정 아기의 성장 사진(메모 포함).
final babyPhotosProvider =
    StreamProvider.family<List<BabyPhoto>, int>((ref, babyId) {
  return ref.watch(databaseProvider).watchBabyPhotos(babyId);
});

/// 특정 아기의 예방접종 완료 기록 (이름 → 기록).
final vaccinationsProvider =
    StreamProvider.family<Map<String, VaccinationRecord>, int>((ref, babyId) {
  return ref
      .watch(databaseProvider)
      .watchVaccinations(babyId)
      .map((list) => {for (final v in list) v.name: v});
});
