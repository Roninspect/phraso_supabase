import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../core/helper/failure.dart';
import '../../../core/helper/typedefs.dart';
import '../../../models/user_model.dart';

final authRepositoryProvider = riverpod.Provider<AuthRepository>((ref) {
  return AuthRepository(
    client: supabase.Supabase.instance.client,
    googleSignIn: GoogleSignIn(),
  );
});

final authStateProvider = riverpod.StreamProvider<supabase.AuthState?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final userDetailsProvider =
    riverpod.FutureProvider.family<UserModel, String>((ref, id) async {
  return ref.watch(authRepositoryProvider).getUserDatafromSupabase(id: id);
});

class AuthRepository {
  final supabase.SupabaseClient _client;

  final GoogleSignIn _googleSignIn;
  AuthRepository({
    required supabase.SupabaseClient client,
    required GoogleSignIn googleSignIn,
  })  : _googleSignIn = googleSignIn,
        _client = client;

//* login user function
  FutureVoid loginUser({
    required String email,
    required String password,
  }) async {
    try {
      return right(
        await _client.auth.signInWithPassword(email: email, password: password),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //* listening to auth state changes
  Stream<supabase.AuthState?> get authStateChanges =>
      _client.auth.onAuthStateChange;

  //* registering a user
  FutureVoid registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      supabase.AuthResponse res = await _client.auth.signUp(
        email: email,
        password: password,
      );

      final userModel = UserModel(
          username: name, email: email, profile: "", id: res.user!.id);

      return right(await _client.from('users').insert(userModel.toMap()));
    } catch (e, stk) {
      print(stk);
      return left(Failure(e.toString()));
    }
  }

  //* google sign-in method
  FutureVoid signInWithGoogle() async {
    try {
      /// Web Client ID that you registered with Google Cloud.
      /// This will be used to perform Google sign in on Android.
      const webClientId =
          '631458358877-ga1184oot3gnqb6bveinbmeltjathoe5.apps.googleusercontent.com';

      /// iOS Client ID that you registered with Google Cloud.
      const iosClientId =
          '631458358877-levthnstcok54i20vsro9qufkv70m7ic.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }
      final response = await _client.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final supabase.User user = response.user!;

      final userModel = UserModel(
          username: googleUser.displayName!,
          email: user.email!,
          profile: googleUser.photoUrl!,
          id: user.id);

      return right(await _client.from('users').insert(userModel.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<UserModel> getUserDatafromSupabase({required String id}) async {
    try {
      final snap = await _client
          .from('users')
          .select("id, username, email, profile")
          .eq('id', id);

      // Print the retrieved map for debugging

      UserModel userModel = UserModel.fromMap(snap.first);
      return userModel;
    } catch (e) {
      throw e.toString();
    }
  }
}
