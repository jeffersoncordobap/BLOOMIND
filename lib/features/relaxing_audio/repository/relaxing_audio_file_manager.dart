import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImportedRelaxingAudioData {
  final String title;
  final String filePath;
  final String fileName;
  final int? fileSize;

  const ImportedRelaxingAudioData({
    required this.title,
    required this.filePath,
    required this.fileName,
    this.fileSize,
  });
}

class RelaxingAudioFileManager {
  static const String _folderName = 'relaxing_audios';

  Future<ImportedRelaxingAudioData?> pickAndStoreAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final pickedFile = result.files.single;

    if (pickedFile.path == null) {
      return null;
    }

    final originalFile = File(pickedFile.path!);

    if (!await originalFile.exists()) {
      return null;
    }

    final appDirectory = await getApplicationDocumentsDirectory();
    final audioDirectory = Directory(
      p.join(appDirectory.path, _folderName),
    );

    if (!await audioDirectory.exists()) {
      await audioDirectory.create(recursive: true);
    }

    final originalName = p.basename(originalFile.path);
    final safeFileName = _buildSafeFileName(originalName);
    final destinationPath = p.join(audioDirectory.path, safeFileName);

    final copiedFile = await originalFile.copy(destinationPath);

    final title = _buildTitleFromFileName(originalName);
    final fileSize = await copiedFile.length();

    return ImportedRelaxingAudioData(
      title: title,
      filePath: copiedFile.path,
      fileName: originalName,
      fileSize: fileSize,
    );
  }

  Future<bool> deleteStoredAudio(String filePath) async {
    try {
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  String _buildSafeFileName(String originalName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = p.extension(originalName);
    final baseName = p.basenameWithoutExtension(originalName);

    final normalizedBaseName = baseName
        .trim()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '');

    return '${normalizedBaseName}_$timestamp$extension';
  }

  String _buildTitleFromFileName(String fileName) {
    final baseName = p.basenameWithoutExtension(fileName).trim();

    if (baseName.isEmpty) {
      return 'Audio relajante';
    }

    final withSpaces = baseName.replaceAll(RegExp(r'[_\-]+'), ' ');

    return withSpaces
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map(
          (word) => word[0].toUpperCase() + word.substring(1).toLowerCase(),
    )
        .join(' ');
  }
}