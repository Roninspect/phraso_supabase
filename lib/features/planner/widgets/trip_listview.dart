import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/features/planner/widgets/trip_card.dart';
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
              // //* sorting to closest one first
              trips.sort((a, b) {
                final DateTime aStartDate = a.itineraries!.start_date;
                final DateTime bStartDate = b.itineraries!.start_date;
                final DateTime today = DateTime.now();

                // Calculate the difference between the start_date and today's date
                final Duration aDifference = aStartDate.difference(today);
                final Duration bDifference = bStartDate.difference(today);

                // Compare the differences
                return aDifference.compareTo(bDifference);
              });
              final trip = trips[index];

              return TripCard(plannerModel: trip.itineraries!);
            },
          );
        },
      ),
    );
  }
}
