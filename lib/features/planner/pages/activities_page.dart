// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phraso/models/activities.dart';
import 'package:timelines/timelines.dart';

import 'package:phraso/core/colors/colors.dart';
import 'package:phraso/core/common/loader.dart';
import 'package:phraso/features/planner/repository/planner_repository.dart';
import 'package:phraso/router/router.dart';

class ActivitiesPage extends ConsumerWidget {
  final String itineraryId;
  final String day_id;
  final DateTime dayDate;
  const ActivitiesPage({
    super.key,
    required this.itineraryId,
    required this.day_id,
    required this.dayDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ref.watch(getAllActivitiesByIdProvider(day_id)).when(
            data: (activities) {
              return activities.isEmpty
                  ? const Center(
                      child: Text("No Activities"),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Timeline.builder(
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          //** extracting each activity from the map */

                          final Activities activity = activities[index];

                          String startTimeFormat =
                              DateFormat('h:mm a').format(activity.startTime);
                          String endTimeFormat =
                              DateFormat('h:mm a').format(activity.endTime);

                          //** timeline tile */

                          return Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                print(
                                    activity.endTime.isBefore(DateTime.now()));
                              },
                              child: TimelineTile(
                                nodeAlign: TimelineNodeAlign.start,
                                mainAxisExtent: 100,

                                contents: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                          width: 300,
                                          child: Text(
                                            activity.place,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              '$startTimeFormat - $endTimeFormat',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //** timeline node */
                                node: TimelineNode(
                                  indicator: DotIndicator(
                                    position: 0.1,
                                    size: 25,
                                    border: Border.all(),
                                    color: activity.isPassed
                                        ? yellowColor
                                        : Colors.transparent,
                                  ),
                                  startConnector: index == 0
                                      ? null
                                      : const SolidLineConnector(
                                          color: Colors.black,
                                          thickness: 1.5,
                                        ),
                                  endConnector: index == activities.length - 1
                                      ? null
                                      : const SolidLineConnector(
                                          color: Colors.black,
                                          thickness: 1.5,
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
            },
            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
            loading: () => Center(
              child: loader(),
            ),
          ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Activities"),
        backgroundColor: yellowColor,
        elevation: 2,
        onPressed: () {
          context.pushNamed(
            AppRoutes.edit_activities.name,
            pathParameters: {'itineraryId': itineraryId, 'day_id': day_id},
            extra: dayDate,
          );
        },
      ),
    );
  }
}
