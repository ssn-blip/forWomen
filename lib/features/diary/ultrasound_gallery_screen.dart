import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_calc.dart';
import '../../core/utils/image_storage.dart';
import '../pregnancy/pregnancy_providers.dart';
import 'diary_providers.dart';

class UltrasoundGalleryScreen extends ConsumerWidget {
  const UltrasoundGalleryScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1600);
    if (picked == null) return;
    final saved = await ImageStorage.persist(picked.path, subdir: 'ultrasound');

    // 진행 중 임신이 있으면 촬영 시점 주차를 자동 추정.
    final preg = ref.read(activePregnancyProvider).value;
    final now = DateTime.now();
    int? week;
    if (preg != null) {
      week = DateCalc.gestationalAge(preg.lastPeriodStart, now).week;
    }

    await ref.read(databaseProvider).insertUltrasound(UltrasoundPhotosCompanion(
          takenAt: Value(now),
          week: Value(week),
          path: Value(saved),
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(ultrasoundProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('초음파 앨범')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.add_a_photo),
        label: const Text('사진 추가'),
      ),
      body: photosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (photos) {
          if (photos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.photo_library,
                        size: 64, color: AppTheme.secondary),
                    const SizedBox(height: 16),
                    Text('초음파 사진을 모아 아기의 성장을 기록해요',
                        style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: photos.length,
            itemBuilder: (context, i) =>
                _UltrasoundTile(photo: photos[i]),
          );
        },
      ),
    );
  }
}

class _UltrasoundTile extends ConsumerWidget {
  const _UltrasoundTile({required this.photo});

  final UltrasoundPhoto photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _viewFull(context),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(photo.path), fit: BoxFit.cover),
                  if (photo.week != null)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${photo.week}주',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                      ),
                    ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(databaseProvider).deleteUltrasound(photo.id),
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black45,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                DateFormat('yyyy.MM.dd', 'ko').format(photo.takenAt),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewFull(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: InteractiveViewer(
          child: Image.file(File(photo.path)),
        ),
      ),
    );
  }
}
