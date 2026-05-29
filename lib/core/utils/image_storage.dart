import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// image_picker가 돌려주는 임시 파일은 캐시 정리 시 사라질 수 있으므로
/// 앱 문서 디렉터리 하위로 복사해 영구 보관한다. 저장된 경로를 반환한다.
class ImageStorage {
  ImageStorage._();

  static Future<String> persist(String sourcePath, {String subdir = 'photos'}) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, subdir));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final ext = p.extension(sourcePath);
    // 파일명은 호출부에서 고유성이 보장된 source 기준 + 디렉터리 분리로 충돌 방지.
    final name = '${p.basenameWithoutExtension(sourcePath)}$ext';
    final dest = p.join(dir.path, name);
    await File(sourcePath).copy(dest);
    return dest;
  }
}
