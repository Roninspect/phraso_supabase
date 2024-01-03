import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/models/following_model.dart';
import 'package:phraso/models/language_model.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

final sqlHelperProvider = Provider<SqlHelper>((ref) {
  return SqlHelper();
});

class SqlHelper {
  Future<void> createTables(sqflite.Database database) async {
    await database.execute("""CREATE TABLE languages(
      id TEXT PRIMARY KEY NOT NULL,
      languageName TEXT,
      background TEXT,
      color TEXT,
      textColor TEXT
    )
    """);

    await database.execute("""CREATE TABLE flags(
      id TEXT PRIMARY KEY NOT NULL,
      name TEXT,
      flag_url TEXT,
      lang_id TEXT, 
      FOREIGN KEY (lang_id) REFERENCES languages (id)
    )
    """);

    await database.execute("""CREATE TABLE followings(
      id TEXT PRIMARY KEY NOT NULL,
      languages TEXT
    )
    """);
  }

  Future<sqflite.Database> db() async {
    return sqflite.openDatabase(
      'phraso.db',
      version: 1,
      onCreate: (sqflite.Database db, int version) async {
        await createTables(db);
      },
    );
  }
}
