// ignore_for_file: void_checks

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phraso/core/helper/failure.dart';
import 'package:phraso/core/helper/typedefs.dart';
import 'package:phraso/models/activities.dart';
import 'package:phraso/models/itinerary_member.dart';
import 'package:phraso/models/itinerary_model.dart';
import 'package:phraso/models/planned_days_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:uuid/uuid.dart';

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

final getPlannedDaysProvider =
    FutureProvider.family<List<PlannedDaysModel>, String>(
        (ref, itineraryId) async {
  return ref
      .watch(plannerRepositoryrovider)
      .getAllPlannedDays(itineraryId: itineraryId);
});

final getAllActivitiesByIdProvider =
    FutureProvider.family<List<Activities>, String>((ref, plannedDaysId) async {
  return ref
      .watch(plannerRepositoryrovider)
      .getAllActivitiesById(plannedDaysId: plannedDaysId);
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

  //** getting all Itineraries that is Active */

  Future<List<ItineraryMember>> getTrips({required String uid}) async {
    try {
      final List<dynamic> res = await _client
          .from('itinerary_members')
          .select('*, itineraries!inner(*)')
          .eq('userId', uid)
          .eq('itineraries.is_active', true)
          .gte('itineraries.end_date', DateTime.now());

      List<ItineraryMember> itineraries =
          res.map((e) => ItineraryMember.fromMap(e)).toList();

      return itineraries;
    } catch (e) {
      throw e.toString();
    }
  }

  //* create a new plan

  FutureVoid createPlan(
      {String? image,
      required String tripName,
      required String placeName,
      required DateTime startTime,
      required String uid,
      required DateTime endTime}) async {
    try {
      final itineraryId = const Uuid().v4();
      final newPlan = ItineraryModel(
          tripId: itineraryId,
          tripName: tripName,
          start_date: startTime,
          end_date: endTime,
          creatorId: uid,
          background: image,
          is_active: true,
          place: placeName);

      final newPlanWithoutimage = ItineraryModel(
          tripId: itineraryId,
          tripName: tripName,
          start_date: startTime,
          end_date: endTime,
          creatorId: uid,
          is_active: true,
          place: placeName);

      await _client.from('itineraries').insert(newPlan.toMap());

      final newMember = ItineraryMember(
        itineraryId: itineraryId,
        userId: uid,
        isAdmin: true,
      );

      if (image != null) {
        return right(
            await _client.from('itinerary_members').insert(newMember.toMap()));
      } else {
        return right(await _client
            .from('itinerary_members')
            .insert(newPlanWithoutimage.toMap()));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //* getting all planned Days for by itineraryId

  Future<List<PlannedDaysModel>> getAllPlannedDays(
      {required String itineraryId}) async {
    try {
      final List<dynamic> res = await _client
          .from('planned_days')
          .select()
          .eq('itinerary_id', itineraryId);

      final List<PlannedDaysModel> plannedDays =
          res.map((e) => PlannedDaysModel.fromMap(e)).toList();
      return plannedDays;
    } catch (e) {
      throw e.toString();
    }
  }

  //* getting a activities timeline from a planned days Id

  Future<List<Activities>> getAllActivitiesById(
      {required String plannedDaysId}) async {
    try {
      final List<dynamic> res = await _client
          .from("activities")
          .select()
          .eq('pd_id', plannedDaysId)
          .order('start_time', ascending: true);

      final List<Activities> activities =
          res.map((e) => Activities.fromMap(e)).toList();

      return activities;
    } catch (e) {
      throw e.toString();
    }
  }

  FutureVoid addAnotherDay({required PlannedDaysModel plannedDaysModel}) async {
    try {
      return right(
          await _client.from('planned_days').insert(plannedDaysModel.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //* convert isPassed to true to all passed activites

  Future<void> makePassedActivitiesTrue(
      {required List<Activities> activities}) async {
    try {
      final List<Map<String, dynamic>> updateData = activities
          .where((e) => e.endTime.isBefore(DateTime.now()))
          .map((e) => e.copyWith(isPassed: true).toMap()) // Corrected line
          .toList();

      await _client.from('activities').upsert(updateData);
    } catch (e) {
      throw e.toString();
    }
  }

  //** add activities */

  FutureVoid addActivites({required Activities activitiy}) async {
    try {
      return right(await _client.from('activities').insert(activitiy.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //** invalidating all expired trips

  // FutureVoid invalidateExpiredPlan({required String planId})async{
  //   try {

  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

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
