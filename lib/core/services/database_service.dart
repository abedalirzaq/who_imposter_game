import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../features/game/model/word_model.dart';
import '../data/words/all_words.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'imposter_game.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS words_table');
        await _createDB(db, newVersion);
      },
    );
  }

  static Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT,
        category TEXT,
        is_used INTEGER DEFAULT 0
      )
    ''');

    final List<Map<String, String>> initialWords = allWords;

    Batch batch = db.batch();
    for (var w in initialWords) {
      batch.insert('words_table', {
        'word': w['word'],
        'category': w['category'],
        'is_used': 0,
      });
    }
    await batch.commit();
  }

  static Future<List<WordModel>> getWords({String? category}) async {
    final db = await database;

    List<Map<String, dynamic>> maps;
    if (category != null && category != 'عشوائي') {
      maps = await db.query(
        'words_table',
        where: 'category = ? AND is_used = 0',
        whereArgs: [category],
      );

      // If no unused words left in this category, reset and fetch again
      if (maps.isEmpty) {
        await db.update(
          'words_table',
          {'is_used': 0},
          where: 'category = ?',
          whereArgs: [category],
        );
        maps = await db.query(
          'words_table',
          where: 'category = ? AND is_used = 0',
          whereArgs: [category],
        );
      }
    } else {
      maps = await db.query('words_table', where: 'is_used = 0');

      // If no unused words left across all categories, reset everything
      if (maps.isEmpty) {
        await db.update('words_table', {'is_used': 0});
        maps = await db.query('words_table', where: 'is_used = 0');
      }
    }

    return List.generate(maps.length, (i) {
      return WordModel.fromMap(maps[i]);
    });
  }

  static Future<void> markWordAsUsed(int id) async {
    final db = await database;
    await db.update(
      'words_table',
      {'is_used': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> resetUsedWords() async {
    final db = await database;
    await db.update('words_table', {'is_used': 0});
  }

  static Future<List<String>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'words_table',
      columns: ['category'],
      distinct: true,
    );
    return maps.map((m) => m['category'] as String).toList();
  }
}
