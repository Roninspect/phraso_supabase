import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/helper/local_sql_helper.dart';
import 'package:phraso/models/flags.dart';
import 'package:phraso/models/following_model.dart';
import 'package:phraso/models/language_model.dart';
import 'package:sqflite/sqflite.dart';

final localLanguageRepositoryProvider =
    Provider<LocalLanguageRepository>((ref) {
  return LocalLanguageRepository(sqlHelper: ref.watch(sqlHelperProvider));
});

final getAllLocalLanguagesProvider =
    FutureProvider<List<LanguageModel>>((ref) async {
  return ref.watch(localLanguageRepositoryProvider).getAllLocalLanguages();
});

class LocalLanguageRepository {
  final SqlHelper _db;

  LocalLanguageRepository({required SqlHelper sqlHelper}) : _db = sqlHelper;

  Future<void> insertSingleLanguage({required LanguageModel language}) async {
    try {
      final db = await _db.db();

      await db.transaction((txn) async {
        // Insert language into the 'languages' table
        await txn.insert(
          'languages',
          language.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Insert flags into the 'flags' table with the corresponding lang_id
        for (Flags flag in language.flags) {
          await txn.insert(
            'flags',
            flag.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<LanguageModel>> getAllLocalLanguages() async {
    try {
      final db = await _db.db();
      List<Map<String, Object?>> resultList = await db.rawQuery('''
      SELECT languages.id, languages.languageName, languages.background, languages.color, languages.textColor, flags.id as flag_id, flags.name as flag_name, flags.flag_url
      FROM languages
      INNER JOIN flags ON languages.id = flags.lang_id
    ''');

      print('from local: $resultList');

      Map<String, LanguageModel> languageMap = {};

      for (Map<String, Object?> row in resultList) {
        String languageId = row['id'] as String;

        if (!languageMap.containsKey(languageId)) {
          languageMap[languageId] = LanguageModel.fromMap({
            'id': languageId,
            'languageName': row['languageName'] as String,
            'background': row['background'] as String,
            'color': row['color'] as String,
            'textColor': row['textColor'] as String,
            'flags': [],
          });
        }

        if (row['flag_id'] != null) {
          languageMap[languageId]?.flags.add(Flags(
                id: row['flag_id'] as String,
                name: row['flag_name'] as String,
                lang_id: languageId,
                flag_url: row['flag_url'] as String,
              ));
        }
      }

      return languageMap.values.toList();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<int> getLanguageCount() async {
    try {
      final db = await _db.db();
      final List<Map<String, dynamic>> result =
          await db.rawQuery('SELECT COUNT(*) FROM languages');

      int count = Sqflite.firstIntValue(result) ?? 0;
      return count;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> insertFollowing(FollowingModel following) async {
    final db = await _db.db(); // Replace with your method to get the database

    await db.insert(
      'followings',
      following.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
