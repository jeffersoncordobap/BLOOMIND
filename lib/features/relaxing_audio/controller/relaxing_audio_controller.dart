import 'package:flutter/material.dart';
import '../model/relaxing_audio_model.dart';
import '../repository/relaxing_audio_repository.dart';
import '../repository/relaxing_audio_file_manager.dart';
import '../repository/relaxing_audio_player_service.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
class RelaxingAudioController extends ChangeNotifier {
  final RelaxingAudioRepository _repository;
  final RelaxingAudioFileManager _fileManager = RelaxingAudioFileManager();
  RelaxingAudioController(this._repository) {
    _playerStateSubscription =
        _playerService.player.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            _currentPlayingAudioId = null;
            _currentPosition = Duration.zero;
          }
          notifyListeners();
        });

    _positionSubscription =
        _playerService.player.positionStream.listen((position) {
          _currentPosition = position;
          notifyListeners();
        });

    _durationSubscription =
        _playerService.player.durationStream.listen((duration) {
          _totalDuration = duration ?? Duration.zero;
          notifyListeners();
        });
  }

  final List<RelaxingAudioModel> _audios = [];
  final List<RelaxingAudioModel> _favoriteAudios = [];
  final RelaxingAudioPlayerService _playerService = RelaxingAudioPlayerService();

  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;

  int? _currentPlayingAudioId;

  int? get currentPlayingAudioId => _currentPlayingAudioId;
  bool get isPlaying => _playerService.player.playing;

  bool _isLoading = false;
  String? _errorMessage;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  double? _dragProgress;
  double? get dragProgress => _dragProgress;
  double get progressValue {
    if (_totalDuration.inMilliseconds == 0) return 0;
    return _currentPosition.inMilliseconds / _totalDuration.inMilliseconds;
  }

  List<RelaxingAudioModel> get audios => List.unmodifiable(_audios);
  List<RelaxingAudioModel> get favoriteAudios =>
      List.unmodifiable(_favoriteAudios);

  int get favoriteAudiosCount => _favoriteAudios.length;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> seekToRelativePosition(double value) async {
    if (_totalDuration.inMilliseconds <= 0) return;

    final newPosition = Duration(
      milliseconds: (_totalDuration.inMilliseconds * value).round(),
    );

    await _playerService.seek(newPosition);
  }
  void updateDragProgress(double value) {
    _dragProgress = value;
    notifyListeners();
  }

  Future<void> commitSeek(double value) async {
    _dragProgress = null;

    if (_totalDuration.inMilliseconds <= 0) return;

    final newPosition = Duration(
      milliseconds: (_totalDuration.inMilliseconds * value).round(),
    );

    await _playerService.seek(newPosition);
    notifyListeners();
  }
  Future<void> loadAudios() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _repository.getAllAudios();
      _audios
        ..clear()
        ..addAll(result);
    } catch (e) {
      _errorMessage = 'No se pudieron cargar los audios.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadFavoriteAudios() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _repository.getFavoriteAudios();
      _favoriteAudios
        ..clear()
        ..addAll(result);
    } catch (e) {
      _errorMessage = 'No se pudieron cargar los audios favoritos.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickAndImportAudio() async {
    print('1. Inicia importación');

    final importedAudio = await _fileManager.pickAndStoreAudio();
    print('2. Resultado picker: $importedAudio');

    if (importedAudio == null) return;

    final audio = RelaxingAudioModel(
      title: importedAudio.title,
      filePath: importedAudio.filePath,
      fileName: importedAudio.fileName,
      fileSize: importedAudio.fileSize,
      durationSeconds: importedAudio.durationSeconds,
      isFavorite: false,
    );

    print('3. Modelo creado: $audio');

    await _repository.insertAudio(audio);
    print('4. Audio insertado en BD');

    await loadAudios();
    print('5. Lista recargada');
  }

  Future<void> addAudio(RelaxingAudioModel audio) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.insertAudio(audio);
      await loadAudios();
      await loadFavoriteAudios();
    } catch (e) {
      _errorMessage = 'No se pudo guardar el audio.';
      _setLoading(false);
      notifyListeners();
    }
  }
  Future<void> togglePlay(RelaxingAudioModel audio) async {
    if (audio.id == null) return;

    try {
      final isCurrentAudio = _currentPlayingAudioId == audio.id;
      final isCurrentlyPlaying = _playerService.player.playing;

      if (isCurrentAudio && isCurrentlyPlaying) {
        await _playerService.pause();
      } else if (isCurrentAudio && !isCurrentlyPlaying) {
        await _playerService.resume();
      } else {
        _currentPlayingAudioId = audio.id;
        _currentPosition = Duration.zero;
        _totalDuration = Duration.zero;
        notifyListeners();

        if (audio.isAsset) {
          await _playerService.playAsset(audio.filePath);
        } else {
          await _playerService.playFile(audio.filePath);
        }
      }
    } catch (e) {
      _errorMessage = 'No se pudo reproducir el audio.';
      notifyListeners();
    }
  }
  Future<void> toggleFavorite(RelaxingAudioModel audio) async {
    if (audio.id == null) return;

    _clearError();

    try {
      final newValue = !audio.isFavorite;

      await _repository.updateFavorite(
        audioId: audio.id!,
        isFavorite: newValue,
      );

      await loadAudios();
      await loadFavoriteAudios();
    } catch (e) {
      _errorMessage = 'No se pudo actualizar el favorito.';
      notifyListeners();
    }
  }
  Future<void> initializeAudios() async {
    await insertDefaultAudiosIfNeeded();
    await loadAudios();
  }

  Future<void> deleteAudio(RelaxingAudioModel audio) async {
    if (audio.id == null) return;

    _setLoading(true);
    _clearError();

    try {
      await _repository.deleteAudio(audio.id!);
      await loadAudios();
      await loadFavoriteAudios();
    } catch (e) {
      _errorMessage = 'No se pudo eliminar el audio.';
      _setLoading(false);
      notifyListeners();
    }
  }
  Future<void> insertDefaultAudiosIfNeeded() async {
    final audios = await _repository.getAllAudios();

    if (audios.any((audio) => audio.isAsset)) return;

    final defaultAudios = [
      RelaxingAudioModel(
        title: 'Lluvia suave',
        filePath: 'assets/audios/lluvia.mp3',
        fileName: 'lluvia.mp3',
        durationSeconds: null,
        isFavorite: false,
        isAsset: true,
      ),
      RelaxingAudioModel(
        title: 'Bosque tranquilo',
        filePath: 'assets/audios/Naturaleza1.mp3',
        fileName: 'Naturaleza1.mp3',
        durationSeconds: null,
        isFavorite: false,
        isAsset: true,
      ),
      RelaxingAudioModel(
        title: 'Naturaleza relajante',
        filePath: 'assets/audios/Naturaleza2.mp3',
        fileName: 'Naturaleza2.mp3',
        durationSeconds: null,
        isFavorite: false,
        isAsset: true,
      ),
      RelaxingAudioModel(
        title: 'Relajacion',
        filePath: 'assets/audios/Relajacion.mp3',
        fileName: 'Relajacion.mp3',
        durationSeconds: null,
        isFavorite: false,
        isAsset: true,
      ),
    ];

    for (final audio in defaultAudios) {
      await _repository.insertAudio(audio);
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerService.dispose();
    super.dispose();
  }
}