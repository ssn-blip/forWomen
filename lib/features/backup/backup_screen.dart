import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/backup/backup_service.dart';
import '../../core/theme/app_theme.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;

  Future<void> _export() async {
    setState(() => _busy = true);
    try {
      final json = await ref.read(backupServiceProvider).exportJson();
      final dir = await getTemporaryDirectory();
      final file = File(p.join(dir.path, 'momcare_backup.json'));
      await file.writeAsString(json);
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '맘케어 데이터 백업',
      );
    } catch (e) {
      _snack('내보내기 실패: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('백업 가져오기'),
        content: const Text('백업 JSON 파일을 선택해 복원합니다.\n'
            '⚠️ 현재 데이터는 백업 내용으로 대체됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('파일 선택'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final path = result?.files.singleOrNull?.path;
    if (path == null) return;

    setState(() => _busy = true);
    try {
      final content = await File(path).readAsString();
      await ref.read(backupServiceProvider).importJson(content);
      _snack('복원이 완료됐어요. 일부 화면은 다시 들어가면 반영됩니다.');
    } catch (e) {
      _snack('가져오기 실패: 올바른 맘케어 백업 파일인지 확인해 주세요.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('백업·동기화')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: AppTheme.secondary.withValues(alpha: 0.1),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '모든 기록을 JSON 파일로 내보내 보관하고, 새 기기에서 다시 가져올 수 있어요.\n'
                    '클라우드 자동 동기화는 로그인 연동 후 제공됩니다.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.upload_file,
                      color: AppTheme.primary),
                  title: const Text('데이터 내보내기'),
                  subtitle: const Text('백업 파일을 공유(저장·전송)합니다'),
                  onTap: _busy ? null : _export,
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.download,
                      color: AppTheme.secondary),
                  title: const Text('데이터 가져오기'),
                  subtitle: const Text('백업 JSON으로 복원합니다'),
                  onTap: _busy ? null : _import,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text('사진은 경로만 백업되며 이미지 파일 자체는 포함되지 않습니다.',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                  ),
                ],
              ),
            ],
          ),
          if (_busy)
            Container(
              color: Colors.black12,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
