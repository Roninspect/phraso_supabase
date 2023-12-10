import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/constants/firebase_enums.dart';
import 'package:phraso/models/double_argsModel.dart';
import 'package:phraso/models/itinerary_member.dart';
import 'package:phraso/models/itinerary_model.dart';
import 'package:phraso/models/plan_model.dart';
import 'package:phraso/models/planned_days_model.dart';
import 'package:phraso/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class ArgsModelForPlanner {
  final String tripId;
  final String planId;
  ArgsModelForPlanner({
    required this.tripId,
    required this.planId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArgsModelForPlanner &&
        other.tripId == tripId &&
        other.planId == planId;
  }

  @override
  int get hashCode => tripId.hashCode ^ planId.hashCode;
}

final plannerRepositoryrovider = Provider<PlannerRepository>((ref) {
  return PlannerRepository(client: supabase.Supabase.instance.client);
});

final getTripsProvider = FutureProvider<List<ItineraryMember>>((ref) {
  return ref
      .watch(plannerRepositoryrovider)
      .getTrips(uid: supabase.Supabase.instance.client.auth.currentUser!.id);
});

// final getMembersProvider =
//     StreamProvider.family<UserModel, String>((ref, memberId) {
//   return ref.watch(plannerRepositoryrovider).getMembers(memberId: memberId);
// });

// final getPlansByIdProvider =
//     StreamProvider.family<List<PlanModel>, String>((ref, tripId) {
//   return ref.watch(plannerRepositoryrovider).getPlansById(tripId: tripId);
// });

// final getPlannedDaysByIdsProvider =
//     StreamProvider.family<List<PlannedDaysModel>, String>((ref, tripId) {
//   return ref
//       .watch(plannerRepositoryrovider)
//       .getPlannedDaysByIds(tripId: tripId);
// });

class PlannerRepository {
  final supabase.SupabaseClient _client;
  PlannerRepository({required supabase.SupabaseClient client})
      : _client = client;

  //** getting all Itineraries */

  Future<List<ItineraryMember>> getTrips({required String uid}) async {
    try {
      final List<dynamic> res = await _client
          .from('itinerary_members')
          .select('*, itineraries(*)')
          .eq('userId', uid);

      print(res);

      List<ItineraryMember> itineraries =
          res.map((e) => ItineraryMember.fromMap(e)).toList();

      return itineraries;
    } catch (e) {
      throw e.toString();
    }
  }

  // //** getting user Info by Id */

  // Stream<UserModel> getMembers({required String memberId}) {
  //   return _firestore
  //       .collection(FirebaseEnums.users.name)
  //       .doc(memberId)
  //       .snapshots()
  //       .map(
  //           (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  // }

  // //** getting all the plan by tripId */

  // Stream<List<PlanModel>> getPlansById({required String tripId}) {
  //   return _firestore
  //       .collection(FirebaseEnums.plans.name)
  //       .where('tripId', isEqualTo: tripId)
  //       .snapshots()
  //       .map((event) =>
  //           event.docs.map((e) => PlanModel.fromMap(e.data())).toList());
  // }

  // //** get all the plans by planid and tripId */
  // //*(might be a worst solution, find a better one) */
  // Stream<List<PlannedDaysModel>> getPlannedDaysByIds({required String tripId}) {
  //   return _firestore
  //       .collection(FirebaseEnums.plannedDays.name)
  //       .where('tripId', isEqualTo: tripId)
  //       .orderBy('dayNo', descending: false)
  //       .snapshots()
  //       .map(
  //         (event) => event.docs
  //             .map((e) => PlannedDaysModel.fromMap(e.data()))
  //             .toList(),
  //       );
  // }
}
