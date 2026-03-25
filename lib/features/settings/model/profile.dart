class Profile {
  final String nombre;
  final String emoji;
  final String genero;

  const Profile({
    this.nombre = '',
    this.emoji = '😊',
    this.genero = '',
  });

  Profile copyWith({String? nombre, String? emoji, String? genero}) => Profile(
        nombre: nombre ?? this.nombre,
        emoji: emoji ?? this.emoji,
        genero: genero ?? this.genero,
      );

  // Saludo dinámico según género
  String get saludo {
    final base = nombre.isNotEmpty ? nombre : 'tú';
    switch (genero) {
      case 'Femenino':
        return 'Bienvenida, $base';
      case 'Masculino':
        return 'Bienvenido, $base';
      default:
        return 'Bienvenido/a, $base';
    }
  }
}
