import 'package:just_audio/just_audio.dart';

class RelaxingAudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<void> playFile(String filePath) async {
    await _player.setFilePath(filePath);
    _player.play();
  }

  Future<void> resume() async {
    _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }
  Future<void> playAsset(String assetPath) async {
    await _player.setAsset(assetPath);
    _player.play();
  }
}