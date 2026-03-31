import 'package:bloomind/features/settings/model/tema.dart';
import 'package:bloomind/features/settings/repository/settings_tema_repository.dart';
import 'package:bloomind/features/settings/repository/settings_tema_repository_impl.dart';
import 'package:flutter/material.dart';

class TemaProvider extends ChangeNotifier {
  bool modoOscuro = false;
  final ConfigTemasRepository _temasRepository = ConfigTemasRepositoryImpl();

  TemaProvider() {
    _cargarTema();
  }

  Future<void> _cargarTema() async {
    final ConfigTemas? tema = await _temasRepository.getTema();
    modoOscuro = tema?.bool_tema ?? false;
    notifyListeners();
  }

  Future<void> cambiarTema(bool oscuro) async {
    modoOscuro = oscuro;
    final nuevoTema = ConfigTemas(bool_tema: oscuro);
    await _temasRepository.saveTema(nuevoTema);
    notifyListeners();
  }
}