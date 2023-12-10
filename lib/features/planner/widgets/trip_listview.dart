import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phraso/features/planner/widgets/trip_card.dart';

import '../../../core/colors/colors.dart';
import '../../../core/helper/async_value_helper.dart';
import '../repository/planner_repository.dart';

class TripListView extends ConsumerWidget {
  const TripListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: AsyncValueWidget(
        value: ref.watch(getTripsProvider),
        data: (trips) {
          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];

              return TripCard(plannerModel: trip.itineraries);
            },
          );
        },
      ),
    );
  }
}
