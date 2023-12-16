import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phraso/core/common/custom_snackbar.dart';
import 'package:phraso/core/constants/default_background.dart';
import 'package:phraso/core/helper/image_uploader.dart';
import 'package:phraso/features/planner/repository/planner_repository.dart';
import 'package:phraso/models/activities.dart';
import 'package:phraso/models/planned_days_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final plannerControllerProvider =
    StateNotifierProvider<PlannerController, bool>((ref) {
  return PlannerController(
      plannerRepository: ref.watch(plannerRepositoryrovider),
      client: supabase.Supabase.instance.client);
});

class PlannerController extends StateNotifier<bool> {
  final PlannerRepository _plannerRepository;
  final supabase.SupabaseClient _client;
  PlannerController(
      {required PlannerRepository plannerRepository,
      required supabase.SupabaseClient client})
      : _client = client,
        _plannerRepository = plannerRepository,
        super(false);

  Future<void> createPlan(
      {XFile? image,
      required String tripName,
      required String placeName,
      required BuildContext context,
      required DateTime startTime,
      required DateTime endTime}) async {
    state = true;
    String? newImage;

    if (image != null) {
      final imageAsByte = await image.readAsBytes();
      final imageRes = await ImageUpload(client: _client).storeTripImageUrl(
          imageExtensions: image.path.split('.').last.toLowerCase(),
          image: imageAsByte,
          tripName: tripName,
          startDate: "${startTime.month + startTime.day}",
          where: placeName);

      imageRes.fold((l) {
        showSnackbar(context: context, text: l.message);
      }, (r) {
        newImage = r;
      });
    } else {
      newImage = defaultbackground;
    }

    final res = await _plannerRepository.createPlan(
        tripName: tripName,
        placeName: placeName,
        image: newImage,
        startTime: startTime,
        uid: supabase.Supabase.instance.client.auth.currentUser!.id,
        endTime: endTime);
    state = false;

    res.fold(
      (l) => showSnackbar(context: context, text: l.message),
      (r) {
        context.pop();
      },
    );
  }

  Future<void> addActivites(
      {required String plannedDaysId,
      required String tripId,
      required String place,
      required DateTime startTime,
      required BuildContext context,
      required WidgetRef ref,
      required DateTime endTime}) async {
    final newActivity = Activities(
        pdId: plannedDaysId,
        isPassed: false,
        place: place,
        tripId: tripId,
        startTime: startTime,
        endTime: endTime);

    state = true;

    final res = await _plannerRepository.addActivites(activitiy: newActivity);

    state = false;

    res.fold((l) => showSnackbar(context: context, text: l.message), (r) {
      ref.invalidate(getAllActivitiesByIdProvider(plannedDaysId));
      context.pop();
    });
  }

  Future<void> addAnotherDay(
      {required DateTime newDate,
      required String itinerary_id,
      required WidgetRef ref,
      required BuildContext context}) async {
    final PlannedDaysModel newPlannedDays =
        PlannedDaysModel(day_date: newDate, itinerary_id: itinerary_id);

    state = true;

    final res = await _plannerRepository.addAnotherDay(
        plannedDaysModel: newPlannedDays);

    state = false;

    res.fold((l) => showSnackbar(context: context, text: l.message),
        (r) => ref.invalidate(getPlannedDaysProvider));
  }
}
