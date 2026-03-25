import 'package:bloomind/features/resourses/model/support_line.dart';
import 'package:bloomind/features/resourses/repository/support_lines_repository.dart';
import 'package:flutter/material.dart';

class SupportLineController extends ChangeNotifier {
  final SupportLineRepository repository;

  List<SupportLine> _lines = [];
  List<SupportLine> _favoriteLines = [];
  List<SupportLine> _deletedLines = []; // Lista para la papelera
  bool _isLoading = false;

  SupportLineController(this.repository) {
    loadSupportLines();
  }

  List<SupportLine> get lines => _lines;
  List<SupportLine> get favoriteLines => _favoriteLines;
  List<SupportLine> get deletedLines => _deletedLines;
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

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    try {
      _favoriteLines = await getFavoriteSupportLines();
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
      await loadFavorites();
    } catch (e) {
      debugPrint("Error al actualizar favorito: $e");
      await loadSupportLines();
    }
  }

  Future<bool> addSupportLine(SupportLine line) async {
    final result = await repository.insertSupportLine(line);
    if (result > 0) {
      await loadSupportLines();
      await loadFavorites();
      return true;
    }
    return false;
  }

  Future<bool> updateSupportLine(SupportLine line) async {
    if (line.idContact == null) return false;

    try {
      final rowsAffected = await repository.updateSupportLine(line);
      if (rowsAffected > 0) {
        await loadSupportLines();
        await loadFavorites();
        return true;
      }
    } catch (e) {
      debugPrint("Error al editar línea de apoyo: $e");
    }
    return false;
  }

  Future<bool> deleteSupportLine(int id) async {
    try {
      final rowsAffected = await repository.deleteSupportLine(id);
      if (rowsAffected > 0) {
        _lines.removeWhere((l) => l.idContact == id);
        await loadFavorites();
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("Error al eliminar línea de apoyo: $e");
    }
    return false;
  }

  Future<List<SupportLine>> getFavoriteSupportLines() async {
    try {
      return await repository.getFavoriteSupportLines();
    } catch (e) {
      debugPrint("Error al obtener líneas favoritas: $e");
      return [];
    }
  }

  // --- MÉTODOS PARA PAPELERA ---

  /// Carga los contactos que están en la papelera
  Future<void> loadDeletedSupportLines() async {
    _isLoading = true;
    notifyListeners();
    try {
      _deletedLines = await repository.getDeletedSupportLines();
    } catch (e) {
      debugPrint("Error cargando papelera de contactos: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restaura un contacto y actualiza las listas activas
  Future<void> restoreSupportLine(int id) async {
    await repository.restoreSupportLine(id);
    await loadDeletedSupportLines(); // Actualizar papelera
    await loadSupportLines(); // Actualizar lista principal
    await loadFavorites(); // Actualizar favoritos si lo era
  }

  /// Elimina definitivamente de la base de datos
  Future<void> forceDeleteSupportLine(int id) async {
    await repository.forceDeleteSupportLine(id);
    await loadDeletedSupportLines();
  }
}
