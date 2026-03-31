import 'package:bloomind/features/settings/model/tema.dart';

abstract class ConfigTemasRepository {
  Future<void> saveTema(ConfigTemas tema); // guarda o actualiza el tema
  Future<ConfigTemas?> getTema();          // obtiene el tema actual
}