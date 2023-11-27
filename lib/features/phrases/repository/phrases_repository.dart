import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:phraso/core/helper/failure.dart';
import 'package:phraso/core/helper/typedefs.dart';
import 'package:phraso/models/favouriteModel.dart';
import 'package:phraso/models/phrases_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final phrasesRepositoryProvider = Provider<PhrasesRepository>((ref) {
  return PhrasesRepository(client: supabase.Supabase.instance.client);
});

class PhrasesRepository {
  final supabase.SupabaseClient _client;
  PhrasesRepository({required supabase.SupabaseClient client})
      : _client = client;

  //** getting all the phrases by ids */

  Future<List<PhrasesModel>> getPhrasesByIds(
      {required String langId, required int typeId}) async {
    try {
      final List<dynamic> res = await _client
          .from('phrases')
          .select()
          .eq("langId", langId)
          .eq("typeId", typeId);

      List<PhrasesModel> phrases =
          res.map((e) => PhrasesModel.fromMap(e)).toList();

      return phrases;
    } catch (e) {
      throw e.toString();
    }
  }

  //** favouriting a phrase */

  FutureVoid favourtiePhrase({required FavouriteModel favouriteModel}) async {
    try {
      return right(
          await _client.from('favourites').insert(favouriteModel.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //** getting favourite phrase */

  Future<List<FavouriteModel>> getFavourties({
    required String uid,
    required String langId,
  }) async {
    try {
      List<dynamic> res = await _client
          .from("favourites")
          .select("*, phrases(*)")
          .eq('uid', uid)
          .eq('langId', langId);

      List<FavouriteModel> favouritePhrases =
          res.map((e) => FavouriteModel.fromMap(e)).toList();

      return favouritePhrases;
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  //* is Favourited already

  Future<bool> isfavAlready({
    required String uid,
    required String langId,
    required int phraseId,
  }) async {
    try {
      final res = await _client
          .from('favourites')
          .select(
              'uid, langId',
              const supabase.FetchOptions(
                  count: supabase.CountOption.estimated))
          .eq('uid', uid)
          .eq('phraseId', phraseId)
          .eq('langId', langId);

      int count = res.count;

      // Check if count is greater than 0
      if (count > 0) {
        print('User is favorited this phrase!');
        return true;
      } else {
        // Entry does not exist, show something else
        print('User is not following this language course.');
        return false;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  //* removing from favourite */

  FutureVoid removeFromFavourite({
    required int phraseId,
    required String langId,
    required String uid,
  }) async {
    try {
      return right(
        await _client
            .from("favourites")
            .delete()
            .match({'uid': uid, 'phraseId': phraseId, 'langId': langId}),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //* search phrase
  Future<List<PhrasesModel>> getSearchResults(
      {required String query, required String langId}) async {
    try {
      final List<dynamic> res = await _client
          .from('phrases')
          .select('*')
          .textSearch(
            'englishPhrases',
            "$query",
            config: 'english',
          )
          .eq('langId', langId);
      print("from repo: $res");

      List<PhrasesModel> results =
          res.map((e) => PhrasesModel.fromMap(e)).toList();

      return results;
    } catch (e) {
      throw e.toString();
    }
  }
}
