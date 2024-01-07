// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phraso/features/planner/controller/planner_controller.dart';
import 'package:phraso/models/activities.dart';
import 'package:timelines/timelines.dart';

import 'package:phraso/core/colors/colors.dart';
import 'package:phraso/core/shared/loader.dart';
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
    final bool isLoading = ref.watch(plannerControllerProvider);

    String _formatDateWithSuffix(DateTime dateTime) {
      final day = DateFormat('d').format(dateTime);
      final month = DateFormat('MMMM').format(dateTime);

      // Add "th" suffix to the day, handling special cases
      String dayWithSuffix;
      if (day.endsWith('1') && day != '11') {
        dayWithSuffix = '$day' 'st';
      } else if (day.endsWith('2') && day != '12') {
        dayWithSuffix = '$day' 'nd';
      } else if (day.endsWith('3') && day != '13') {
        dayWithSuffix = '$day' 'rd';
      } else {
        dayWithSuffix = '$day' 'th';
      }

      return '$dayWithSuffix $month';
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: ref.watch(getAllActivitiesByIdProvider(day_id)).when(
            data: (activities) {
              return isLoading
                  ? Center(
                      child: loader(),
                    )
                  : activities.isEmpty
                      ? Center(
                          child: Text(
                              "No Activities for ${_formatDateWithSuffix(dayDate)}"),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Timeline.builder(
                            itemCount: activities.length,
                            itemBuilder: (context, index) {
                              //** extracting each activity from the map */

                              final Activities activity = activities[index];

                              String startTimeFormat = DateFormat('h:mm a')
                                  .format(activity.startTime);
                              String endTimeFormat =
                                  DateFormat('h:mm a').format(activity.endTime);

                              //** timeline tile */

                              return Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: TimelineTile(
                                    nodeAlign: TimelineNodeAlign.start,
                                    mainAxisExtent: 100,

                                    contents: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: SizedBox(
                                                  width: 300,
                                                  child: Text(
                                                    activity.place,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              PopupMenuButton(
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    onTap: () => ref
                                                        .read(
                                                            plannerControllerProvider
                                                                .notifier)
                                                        .deleteActivity(
                                                            activityId: activity
                                                                .activitiesId!,
                                                            context: context,
                                                            plannedDaysId:
                                                                activity.pdId,
                                                            ref: ref),
                                                    child: const Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Delete Activity",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
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
                                        color: activity.endTime
                                                .toUtc()
                                                .isBefore(
                                                    DateTime.now().toUtc())
                                            ? yellowColor
                                            : Colors.transparent,
                                      ),
                                      startConnector: index == 0
                                          ? null
                                          : const SolidLineConnector(
                                              color: Colors.black,
                                              thickness: 1.5,
                                            ),
                                      endConnector:
                                          index == activities.length - 1
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
