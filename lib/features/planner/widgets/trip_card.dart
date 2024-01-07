// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phraso/core/shared/custom_snackbar.dart';
import 'package:phraso/models/itinerary_model.dart';
import 'package:phraso/router/router.dart';
import '../../../core/colors/colors.dart';

class TripCard extends ConsumerStatefulWidget {
  final ItineraryModel plannerModel;
  const TripCard({
    super.key,
    required this.plannerModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TripCardState();
}

class _TripCardState extends ConsumerState<TripCard> {
  @override
  Widget build(BuildContext context) {
    final ItineraryModel plannerModel = widget.plannerModel;

    //** calculating is trip running or not */

    DateTime now = DateTime.now();
    DateTime targetDate = plannerModel.start_date;
    Duration difference = targetDate.difference(now);
    bool isRunning = plannerModel.start_date.isBefore(now) &&
        plannerModel.end_date.isAfter(now);
    bool isPast = plannerModel.start_date.isBefore(now) &&
        plannerModel.end_date.isBefore(now);
    int daysLeft = difference.inDays;

    //** formatting the dates and time */
    String formattedStartDate =
        DateFormat('MMM d').format(plannerModel.start_date);
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
        context.pushNamed(
          AppRoutes.itinerary.name,
          pathParameters: {'itineraryId': widget.plannerModel.tripId},
        );
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
                          child: isRunning
                              ? const Text(
                                  'Now',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              : isPast
                                  ? Text(
                                      DateFormat('MMM d')
                                          .format(plannerModel.start_date),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      '${daysLeft.toString()} days left',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
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
