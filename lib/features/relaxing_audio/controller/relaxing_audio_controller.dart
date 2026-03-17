import 'package:flutter/material.dart';

import '../model/relaxing_audio_model.dart';
import '../repository/relaxing_audio_repository.dart';
import '../repository/relaxing_audio_file_manager.dart';

class RelaxingAudioController extends ChangeNotifier {
  final RelaxingAudioRepository _repository;
  final RelaxingAudioFileManager _fileManager = RelaxingAudioFileManager();
  RelaxingAudioController(this._repository);

  final List<RelaxingAudioModel> _audios = [];
  final List<RelaxingAudioModel> _favoriteAudios = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<RelaxingAudioModel> get audios => List.unmodifiable(_audios);
  List<RelaxingAudioModel> get favoriteAudios =>
      List.unmodifiable(_favoriteAudios);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
      durationSeconds: null,
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
}