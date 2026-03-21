import 'package:bloomind/features/resourses/model/surprise_activity.dart';

abstract class SurpriseActivityRepository {
  Future<List<SurpriseActivity>> getAll();
  Future<void> insert(SurpriseActivity activity);
  Future<int> count();
  Future<void> toggleFavorito(int id, bool isFavorite);
  Future<List<SurpriseActivity>> getFavoritos();
  Future<int> countFavoritos();
}
