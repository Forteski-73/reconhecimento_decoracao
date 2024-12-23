class Decoracao {
  final int     id;
  final String  codigo;
  final double  x;
  final double  y;

  Decoracao({required this.id, required this.codigo, required this.x, required this.y});

  Map<String, dynamic> toMap() {
    return {
      'id':     id,
      'codigo': codigo,
      'x':      x,
      'y':      y,
    };
  }

  factory Decoracao.fromMap(Map<String, dynamic> map) {
    return Decoracao(
      id:     map['id'],
      codigo: map['codigo'],
      x:      map['x'],
      y:      map['y'],
    );
  }
}
