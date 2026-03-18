import 'package:bloomind/features/resourses/model/support_line.dart';
import 'package:bloomind/features/resourses/repository/support_lines_repository.dart';
import 'package:flutter/material.dart';

class SupportLineController extends ChangeNotifier {
  final SupportLineRepository repository;

  List<SupportLine> _lines = [];
  bool _isLoading = false;

  SupportLineController(this.repository) {
    loadSupportLines();
  }

  List<SupportLine> get lines => _lines;
  bool get isLoading => _isLoading;

  Future<void> loadSupportLines() async {
    _isLoading = true;
    notifyListeners();
    try {
      _lines = await repository.getAllSupportLines();
    } catch (e) {
      debugPrint("Error al cargar líneas de apoyo: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(SupportLine line) async {
    if (line.idContact == null) return;

    final int index = _lines.indexWhere((l) => l.idContact == line.idContact);
    if (index == -1) return;

    final newStatus = !line.isFavorite;
    _lines[index] = SupportLine(
      idContact: line.idContact,
      name: line.name,
      phone: line.phone,
      description: line.description,
      isFavorite: newStatus,
    );
    notifyListeners();
    try {
      await repository.updateFavoriteStatus(line.idContact!, newStatus);
    } catch (e) {
      debugPrint("Error al actualizar favorito: $e");
      await loadSupportLines();
    }
  }

  Future<bool> addSupportLine(SupportLine line) async {
    final result = await repository.insertSupportLine(line);
    if (result > 0) {
      await loadSupportLines();
      return true;
    }
    return false;
  }
}
