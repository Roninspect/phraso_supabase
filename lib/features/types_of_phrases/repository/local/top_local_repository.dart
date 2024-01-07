import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/helper/local_sql_helper.dart';
import 'package:phraso/models/top_model.dart';
import 'package:sqflite/sqflite.dart';

final localTopRepositoryProvider = Provider<LocalTopRepository>((ref) {
  return LocalTopRepository(db: ref.watch(sqlHelperProvider));
});

class LocalTopRepository {
  SqlHelper _db;
  LocalTopRepository({required SqlHelper db}) : _db = db;

  Future<List<TypesOfPhrasesmodel>> getTypesofPhrasesList() async {
    try {
      print('from local top');
      final db = await _db.db();

      final res = await db.query('top');

      final List<TypesOfPhrasesmodel> typesOfPhrases =
          res.map((e) => TypesOfPhrasesmodel.fromMap(e)).toList();

      return typesOfPhrases;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> insertTOP({required TypesOfPhrasesmodel top}) async {
    try {
      final db = await _db.db();
      await db.insert(
        'top',
        top.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw e.toString();
    }
  }
}
