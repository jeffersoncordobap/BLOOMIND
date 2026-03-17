import '../../../core/database/database_config.dart';

class RelaxingAudioModel {
  final int? id;
  final String title;
  final int? durationSeconds;
  final String filePath;
  final String? fileName;
  final int? fileSize;
  final bool isFavorite;
  final String? createdAt;

  const RelaxingAudioModel({
    this.id,
    required this.title,
    this.durationSeconds,
    required this.filePath,
    this.fileName,
    this.fileSize,
    this.isFavorite = false,
    this.createdAt,
  });

  RelaxingAudioModel copyWith({
    int? id,
    String? title,
    int? durationSeconds,
    String? filePath,
    String? fileName,
    int? fileSize,
    bool? isFavorite,
    String? createdAt,
  }) {
    return RelaxingAudioModel(
      id: id ?? this.id,
      title: title ?? this.title,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseConfig.recRelaxingAudioId: id,
      DatabaseConfig.recRelaxingAudioTitle: title,
      DatabaseConfig.recRelaxingAudioDurationSeconds: durationSeconds,
      DatabaseConfig.recRelaxingAudioFilePath: filePath,
      DatabaseConfig.recRelaxingAudioFileName: fileName,
      DatabaseConfig.recRelaxingAudioFileSize: fileSize,
      DatabaseConfig.recRelaxingAudioIsFavorite: isFavorite ? 1 : 0,
      DatabaseConfig.recRelaxingAudioCreatedAt: createdAt,
    };
  }

  factory RelaxingAudioModel.fromMap(Map<String, dynamic> map) {
    return RelaxingAudioModel(
      id: map[DatabaseConfig.recRelaxingAudioId] as int?,
      title: map[DatabaseConfig.recRelaxingAudioTitle] as String? ?? '',
      durationSeconds:
      map[DatabaseConfig.recRelaxingAudioDurationSeconds] as int?,
      filePath: map[DatabaseConfig.recRelaxingAudioFilePath] as String? ?? '',
      fileName: map[DatabaseConfig.recRelaxingAudioFileName] as String?,
      fileSize: map[DatabaseConfig.recRelaxingAudioFileSize] as int?,
      isFavorite: (map[DatabaseConfig.recRelaxingAudioIsFavorite] ?? 0) == 1,
      createdAt: map[DatabaseConfig.recRelaxingAudioCreatedAt] as String?,
    );
  }

  @override
  String toString() {
    return 'RelaxingAudioModel('
        'id: $id, '
        'title: $title, '
        'durationSeconds: $durationSeconds, '
        'filePath: $filePath, '
        'fileName: $fileName, '
        'fileSize: $fileSize, '
        'isFavorite: $isFavorite, '
        'createdAt: $createdAt'
        ')';
  }
}