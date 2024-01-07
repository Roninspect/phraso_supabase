import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:phraso/core/helper/failure.dart';
import 'package:phraso/core/helper/typedefs.dart';
import 'package:phraso/models/following_model.dart';
import 'package:phraso/models/language_model.dart';
import 'package:phraso/models/version.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final languageRepositroyProvider = Provider<LanguageRepository>((ref) {
  return LanguageRepository(client: supabase.Supabase.instance.client);
});

class LanguageRepository {
  final supabase.SupabaseClient _client;
  LanguageRepository({required supabase.SupabaseClient client})
      : _client = client;

  //* get all languages
  Future<List<LanguageModel>> getAllLanguage() async {
    try {
      print('from remote');
      final List<dynamic> res =
          await _client.from('languages').select('*, flags(*)');
      List<LanguageModel> languages =
          res.map((e) => LanguageModel.fromMap(e)).toList();

      return languages;
    } catch (e) {
      throw e.toString();
    }
  }

  //* get all languages count
  Future<int> getlanguagesCount() async {
    try {
      final res = await _client
          .from('languages')
          .select('*')
          .count(supabase.CountOption.exact);

      return res.count;
    } catch (e) {
      throw e.toString();
    }
  }

  //* following langugae tile
  FutureVoid followLanguage(
      {required String uid, required String langId}) async {
    try {
      return right(
        await _client.from("followings").insert(
          {"lang_id": langId, "uid": uid},
        ),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //* get following language
  Future<List<FollowingModel>> getFollowingLanguage(
      {required String uid}) async {
    try {
      final List<dynamic> res = await _client
          .from("followings")
          .select('*, languages(*, flags(*))')
          .eq('uid', uid);

      List<FollowingModel> followings =
          res.map((e) => FollowingModel.fromMap(e)).toList();

      return followings;
    } catch (e) {
      throw e.toString();
    }
  }

  //* is Following already

  Future<bool> isFollowingAlready(
      {required String uid, required String langId}) async {
    final res = await _client
        .from('followings')
        .select('uid, lang_id')
        .eq('uid', uid)
        .eq('lang_id', langId)
        .count(supabase.CountOption.exact);

    int count = res.count;

    // Check if count is greater than 0
    if (count > 0) {
      return true;
    } else {
      return false;
    }
  }

  //* unfollowing the following tile

  FutureVoid deleteTheFollowing({
    required String uid,
    required String langId,
  }) async {
    try {
      return right(await _client
          .from('followings')
          .delete()
          .match({'uid': uid, 'lang_id': langId}));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //* search language
  Future<List<LanguageModel>> getSearchResults({required String query}) async {
    try {
      final List<dynamic> res = await _client
          .from('languages')
          .select('*, flags(*)')
          .ilike("languageName", "%$query%");

      List<LanguageModel> results =
          res.map((e) => LanguageModel.fromMap(e)).toList();

      return results;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Version> getVersion() async {
    try {
      final res = await supabase.Supabase.instance.client
          .from('version')
          .select('*')
          .single();

      final Version version = Version.fromMap(res);

      return version;
    } catch (e) {
      throw e.toString();
    }
  }
}
