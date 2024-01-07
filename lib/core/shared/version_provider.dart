import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/helper/local_sql_helper.dart';
import 'package:phraso/models/version.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final versionRepositoryProvider = Provider<VersionRepository>((ref) {
  return VersionRepository(
      client: supabase.Supabase.instance.client,
      db: ref.watch(sqlHelperProvider));
});

final getLocalVersionProvider =
    FutureProvider.autoDispose<Version>((ref) async {
  return await ref.watch(versionRepositoryProvider).getLocalVersion();
});

class VersionRepository {
  final SqlHelper _db;
  final supabase.SupabaseClient _client;
  VersionRepository(
      {required SqlHelper db, required supabase.SupabaseClient client})
      : _db = db,
        _client = client;

  Future<Version> getRemoteVersion() async {
    try {
      final res = await _client.from('version').select('*').single();

      final Version version = Version.fromMap(res);

      return version;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Version> getLocalVersion() async {
    try {
      final db = await _db.db();

      final List<Map<String, dynamic>> result = await db.query('version');

      // Log the result for debugging
      print('Result from getVersion query: $result');

      // Check if the result is not empty before accessing the first element
      if (result.isNotEmpty) {
        return Version.fromMap(result.first);
      } else {
        // Insert a default version if not found
        await insertIntoLocalVersion(
          version: Version(
            id: '880de450-e904-42d2-9a09-c9d322b9aea7',
            langVersion: 0,
            typeVersion: 0,
            phraseUpdated: '50a6fa93-bdd-409a-88f9-73f3f027bd0e_1_1',
          ),
        );

        // Re-fetch the inserted row
        final List<Map<String, dynamic>> insertedResult =
            await db.query('version');

        // Return the fetched Version
        return Version.fromMap(insertedResult.first);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> insertIntoLocalVersion({required Version version}) async {
    try {
      final db = await _db.db();

      await db.insert(
        'version',
        version.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateLangVersion(
      {required int langVersion, required String versionId}) async {
    try {
      final db = await _db.db();

      await db.update(
        'version',
        {'lang_version': langVersion},
        where: 'id = ?',
        whereArgs: [versionId],
      );
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateTypeVersion(
      {required int typeVersion, required String versionId}) async {
    try {
      final db = await _db.db();

      await db.update(
        'version',
        {'type_version': typeVersion},
        where: 'id = ?',
        whereArgs: [versionId],
      );
    } catch (e) {
      throw e.toString();
    }
  }
}
