import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:phraso/core/colors/colors.dart';
import 'package:phraso/core/constants/spacings.dart';
import 'package:phraso/features/planner/widgets/trip_listview.dart';
import 'package:phraso/router/router.dart';

class Plannerpage extends ConsumerWidget {
  const Plannerpage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height * 0.03,
        title: const Text("Trip Planner"),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
                onTap: () => context.pushNamed(AppRoutes.passedTrips.name),
                child: Icon(Octicons.history)),
          )
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            smallSpacing,
            smallSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Upcoming Trips",
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            SizedBox(height: 10),

            //* trip listview
            TripListView(),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black, offset: Offset(1.5, 1.5))],
        ),
        child: FloatingActionButton.extended(
          heroTag: null,
          shape: const CircleBorder(
            side: BorderSide(
              width: 1.7,
            ),
          ),
          backgroundColor: yellowColor,
          elevation: 0,
          label: const Icon(Icons.add, color: Colors.black, size: 28),
          onPressed: () {
            context.pushNamed(AppRoutes.addTrip.name);
          },
        ),
      ),
    );
  }
}
