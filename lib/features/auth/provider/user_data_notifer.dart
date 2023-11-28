import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/features/auth/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/user_model.dart';

final userDataNotifierProvider =
    StateNotifierProvider<UserDataNotifier, UserModel>((ref) {
  return UserDataNotifier(ref);
});

class UserDataNotifier extends StateNotifier<UserModel> {
  UserDataNotifier(this.ref)
      : super(UserModel(
            username: 'loading',
            email: 'loading',
            id: 'loading',
            profile: "loading")) {
    fetchData();
  }

  final Ref ref;

  void fetchData() {
    ref
        .watch(
            userDetailsProvider(Supabase.instance.client.auth.currentUser!.id))
        .when(
            data: (data) {
              state = data;
            },
            error: (error, stackTrace) {
              state = UserModel(
                  id: "$error",
                  username: "$error",
                  email: "$error",
                  profile: "$error");
            },
            loading: () => state = UserModel(
                username: 'loading',
                email: 'loading',
                id: 'loading',
                profile: "loading"));
  }
}
