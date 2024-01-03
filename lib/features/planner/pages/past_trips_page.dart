import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/colors/colors.dart';
import 'package:phraso/core/helper/async_value_helper.dart';
import 'package:phraso/features/planner/repository/planner_repository.dart';
import 'package:phraso/features/planner/widgets/trip_card.dart';

class PastTripsPage extends ConsumerWidget {
  const PastTripsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Past Trips'),
      ),
      body: AsyncValueWidget(
        value: ref.watch(getPassedTripsProvider),
        data: (trips) {
          return trips.isEmpty
              ? const Center(
                  child: Text("No Past Trips"),
                )
              : ListView.builder(
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

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TripCard(plannerModel: trip.itineraries!),
                    );
                  },
                );
        },
      ),
    );
  }
}
