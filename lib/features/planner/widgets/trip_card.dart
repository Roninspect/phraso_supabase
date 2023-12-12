// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phraso/core/common/custom_snackbar.dart';
import 'package:phraso/models/itinerary_model.dart';
import 'package:phraso/router/router.dart';
import '../../../core/colors/colors.dart';

class TripCard extends ConsumerWidget {
  final ItineraryModel plannerModel;
  const TripCard({
    super.key,
    required this.plannerModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //** formatting the dates and time */
    DateTime now = DateTime.now();
    DateTime targetDate = plannerModel.start_date;
    Duration difference = targetDate.difference(now);
    int daysLeft = difference.inDays;

    DateTime startDate = plannerModel.start_date;
    String formattedStartDate = DateFormat('MMM d').format(startDate);
    String shortenedStartDate = formattedStartDate.length > 5
        ? formattedStartDate.substring(0, 4) +
            formattedStartDate.substring(formattedStartDate.indexOf(' '))
        : formattedStartDate;

    DateTime endDate = plannerModel.end_date;
    String formattedEndDate = DateFormat('MMM d').format(endDate);
    String shortenedEndDate = formattedEndDate.length > 5
        ? formattedEndDate.substring(0, 4) +
            formattedEndDate.substring(formattedEndDate.indexOf(' '))
        : formattedEndDate;

    return GestureDetector(
      onTap: () {
        // context.pushNamed(AppRoutes.trip.name,
        //     pathParameters: {'tripName': plannerModel.tripName},
        //     extra: plannerModel);
        showSnackbar(context: context, text: "unmplemented");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
              color: plannerModel.background!.isEmpty ? Colors.green : null,
              border: Border.all(),
              borderRadius: BorderRadius.circular(20),
              image: plannerModel.background!.isEmpty
                  ? null
                  : DecorationImage(
                      image: CachedNetworkImageProvider(
                          plannerModel.background!,
                          cacheKey: plannerModel.tripId),
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(
                          Colors.black26, BlendMode.darken),
                    )),
          child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 270,
                      child: Text(
                        plannerModel.tripName,
                        style: const TextStyle(
                            fontSize: 25, color: sliverTextColor),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: yellowColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black, offset: Offset(2, 2))
                            ]),
                        height: 34,
                        width: 80,
                        child: Center(
                          child: Text(
                            '${daysLeft.toString()} days left',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
                Text(
                  plannerModel.place,
                  style: const TextStyle(fontSize: 21, color: sliverTextColor),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$shortenedStartDate - $shortenedEndDate",
                      style:
                          const TextStyle(fontSize: 21, color: sliverTextColor),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
