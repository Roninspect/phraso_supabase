import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/models/top_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final typesOfPhrasesRepositoryProvider =
    Provider<RemoteTypesOfPhrasesRepository>((ref) {
  return RemoteTypesOfPhrasesRepository(
      client: supabase.Supabase.instance.client);
});

class RemoteTypesOfPhrasesRepository {
  final supabase.SupabaseClient _client;
  RemoteTypesOfPhrasesRepository({required supabase.SupabaseClient client})
      : _client = client;

  Future<List<TypesOfPhrasesmodel>> getTypesofPhrasesList() async {
    try {
      print('from remote top');
      final List<dynamic> res =
          await _client.from("typesOfPhrases").select('id, icon, color, name');

      List<TypesOfPhrasesmodel> top =
          res.map((e) => TypesOfPhrasesmodel.fromMap(e)).toList();
      print(top.length);
      return top;
    } catch (e) {
      throw e.toString();
    }
  }
}
