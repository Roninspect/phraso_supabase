// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phraso/core/colors/colors.dart';
import 'package:phraso/core/common/curtom_back_button.dart';
import 'package:phraso/core/common/custom_snackbar.dart';
import 'package:phraso/core/common/loader.dart';
import 'package:phraso/features/planner/controller/planner_controller.dart';
import 'package:phraso/features/planner/pages/activities_page.dart';
import 'package:phraso/features/planner/repository/planner_repository.dart';

import 'package:phraso/models/itinerary_model.dart';

class PlannedDaysPage extends ConsumerStatefulWidget {
  final ItineraryModel itineraryModel;
  const PlannedDaysPage({
    super.key,
    required this.itineraryModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlannedDaysPageState();
}

class _PlannedDaysPageState extends ConsumerState<PlannedDaysPage> {
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

  String? selectedId;

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(plannerControllerProvider);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        centerTitle: true,
        title: Text(widget.itineraryModel.tripName),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
        ],
      ),
      body: ref
          .watch(getPlannedDaysProvider(widget.itineraryModel.tripId))
          .when(
            data: (data) {
              return DefaultTabController(
                length: data.length,
                child: Column(
                  children: [
                    Row(
                      children: [
                        data.isEmpty
                            ? isLoading
                                ? loader()
                                : InkWell(
                                    onTap: () {
                                      ref
                                          .read(plannerControllerProvider
                                              .notifier)
                                          .addAnotherDay(
                                              newDate: widget
                                                  .itineraryModel.start_date,
                                              itinerary_id:
                                                  widget.itineraryModel.tripId,
                                              ref: ref,
                                              context: context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 120,
                                      color: Colors.green,
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              Text("Add a Day"),
                                              Icon(
                                                Icons.add,
                                                size: 25,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            : Expanded(
                                child: TabBar(
                                    indicatorColor: yellowColor,
                                    labelColor: Colors.black,
                                    isScrollable: true,
                                    tabs: [
                                      ...data.map((e) => Tab(
                                          height: 50,
                                          child: Center(
                                              child: GestureDetector(
                                            child: Text(_formatDateWithSuffix(
                                                e.day_date)),
                                          )))),
                                      isLoading
                                          ? loader()
                                          : InkWell(
                                              onTap: () {
                                                if (widget
                                                    .itineraryModel.end_date
                                                    .isAfter(
                                                        data.last.day_date)) {
                                                  ref
                                                      .read(
                                                          plannerControllerProvider
                                                              .notifier)
                                                      .addAnotherDay(
                                                          newDate: data
                                                              .last.day_date
                                                              .add(
                                                            const Duration(
                                                                days: 1),
                                                          ),
                                                          itinerary_id: widget
                                                              .itineraryModel
                                                              .tripId,
                                                          ref: ref,
                                                          context: context);
                                                } else {
                                                  showSnackbar(
                                                      context: context,
                                                      text:
                                                          "Your Trips's end Date is reached");
                                                }
                                              },
                                              child: const SizedBox(
                                                height: 50,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.green,
                                                    size: 25,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ]),
                              ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: data
                            .map(
                              (e) => ActivitiesPage(
                                  itineraryId: widget.itineraryModel.tripId,
                                  day_id: e.day_id!,
                                  dayDate: e.day_date),
                            )
                            .toList(),
                      ),
                    )
                  ],
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
    );
  }
}
