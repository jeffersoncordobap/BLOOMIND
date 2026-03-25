import '../model/relaxing_audio_model.dart';

abstract class RelaxingAudioRepository {
  Future<List<RelaxingAudioModel>> getAllAudios();

  Future<List<RelaxingAudioModel>> getFavoriteAudios();

  Future<int> insertAudio(RelaxingAudioModel audio);

  Future<int> updateAudio(RelaxingAudioModel audio);

  Future<int> updateFavorite({
    required int audioId,
    required bool isFavorite,
  });

  Future<int> deleteAudio(int audioId);
}