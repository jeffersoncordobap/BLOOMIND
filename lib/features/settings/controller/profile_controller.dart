import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/profile.dart';

class ProfileController extends ChangeNotifier {
  static const _keyNombre = 'profile_nombre';
  static const _keyEmoji = 'profile_emoji';
  static const _keyGenero = 'profile_genero';

  Profile _profile = const Profile();
  Profile get profile => _profile;

  ProfileController() {
    _cargar();
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    _profile = Profile(
      nombre: prefs.getString(_keyNombre) ?? '',
      emoji: prefs.getString(_keyEmoji) ?? '😊',
      genero: prefs.getString(_keyGenero) ?? '',
    );
    notifyListeners();
  }

  Future<void> guardar({
    required String nombre,
    required String emoji,
    required String genero,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNombre, nombre);
    await prefs.setString(_keyEmoji, emoji);
    await prefs.setString(_keyGenero, genero);
    _profile = Profile(nombre: nombre, emoji: emoji, genero: genero);
    notifyListeners();
  }
}
