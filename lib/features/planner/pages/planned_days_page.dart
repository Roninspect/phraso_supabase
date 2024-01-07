// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phraso/core/colors/colors.dart';
import 'package:phraso/core/shared/curtom_back_button.dart';
import 'package:phraso/core/shared/loader.dart';
import 'package:phraso/core/helper/async_value_helper.dart';
import 'package:phraso/features/planner/controller/planner_controller.dart';
import 'package:phraso/features/planner/pages/activities_page.dart';
import 'package:phraso/features/planner/repository/planner_repository.dart';
import 'package:share_plus/share_plus.dart';

class PlannedDaysPage extends ConsumerStatefulWidget {
  final String tripId;
  const PlannedDaysPage({
    super.key,
    required this.tripId,
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
    final data = ref.watch(getSingleItineraryProvider(widget.tripId));

    final RouteMatch lastMatch =
        GoRouter.of(context).routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : GoRouter.of(context).routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();

    String shareableLink = "https://phraso.app$location";

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        title: data.value == null
            ? const SizedBox.shrink()
            : Text(data.valueOrNull!.tripName),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await Share.share(shareableLink);
              },
              icon: const Icon(Icons.share_outlined)),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {},
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.edit),
                    ),
                    Text("Edit Trip Details"),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {},
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.admin_panel_settings),
                    ),
                    Text("Moderation Settings"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: data,
        data: (p0) {
          return ref.watch(getPlannedDaysProvider(p0.tripId)).when(
              data: (data) {
                //* calculating initial index
                int initialIndex = data.indexWhere((element) =>
                    element.day_date.day == DateTime.now().day &&
                    element.day_date.month == DateTime.now().month);

                return DefaultTabController(
                  initialIndex: initialIndex == -1 ? 0 : initialIndex,
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
                                                newDate: p0.start_date,
                                                itinerary_id: p0.tripId,
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
                                            : p0.end_date
                                                    .isAfter(data.last.day_date)
                                                ? InkWell(
                                                    onTap: () {
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
                                                              itinerary_id:
                                                                  p0.tripId,
                                                              ref: ref,
                                                              context: context);
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
                                                  )
                                                : const SizedBox.shrink(),
                                      ]),
                                ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: data
                              .map(
                                (e) => ActivitiesPage(
                                    itineraryId: p0.tripId,
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
                  ));
        },
      ),
    );
  }
}
