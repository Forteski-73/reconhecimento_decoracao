import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/decoracao.dart';

class DatabaseHelper {
  static Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'decoracoes.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE decoracoes(id INTEGER PRIMARY KEY, codigo TEXT, x REAL, y REAL)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertDecoracao(Decoracao decoracao) async {
    final db = await getDatabase();
    await db.insert(
      'decoracoes',
      decoracao.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Decoracao?> getDecoracao(int id) async {
    final db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.query(
      'decoracoes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Decoracao.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
