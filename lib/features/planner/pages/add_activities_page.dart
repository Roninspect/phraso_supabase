// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:phraso/core/colors/colors.dart';
import 'package:phraso/core/shared/curtom_back_button.dart';
import 'package:phraso/core/shared/loader.dart';
import 'package:phraso/core/constants/spacings.dart';
import 'package:phraso/features/planner/controller/planner_controller.dart';
import 'package:phraso/features/planner/repository/planner_repository.dart';
import 'package:phraso/features/planner/widgets/confirm_BTN.dart';
import 'package:phraso/models/planned_days_model.dart';

class AddActivitiesPage extends ConsumerStatefulWidget {
  final String day_id;
  final DateTime dayDate;
  final String tripId;
  const AddActivitiesPage({
    super.key,
    required this.day_id,
    required this.dayDate,
    required this.tripId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddActivitiesPageState();
}

class _AddActivitiesPageState extends ConsumerState<AddActivitiesPage> {
  PlannedDaysModel? selectedDay;
  TextEditingController activitiesController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  late TimeOfDay startTime;
  late TimeOfDay endTime;

  void _showStartTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      startTime = pickedTime!;
      startTimeController.text = pickedTime.format(context).toString();
    });
  }

  void _showEndTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    setState(() {
      endTime = pickedTime!;
      endTimeController.text = pickedTime.format(context).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(plannerControllerProvider);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        title: const Text("Add an Activity"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            blockSpacing,
            const Text("Select Day"),
            SizedBox(
              height: 50,
              child: ref.watch(getPlannedDaysProvider(widget.tripId)).when(
                    data: (data) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final singleDay = data[index];
                          final bool isTimePassed =
                              singleDay.day_date.isAfter(DateTime.now()) ||
                                  singleDay.day_date.day == DateTime.now().day;

                          final formattedDate =
                              DateFormat('dd MMM').format(singleDay.day_date);

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                                onTap: () {
                                  if (isTimePassed) {
                                    setState(() {
                                      selectedDay = singleDay;
                                    });
                                  }
                                },
                                child: Chip(
                                    backgroundColor: selectedDay == singleDay &&
                                            selectedDay != null
                                        ? yellowColor
                                        : isTimePassed
                                            ? Colors.white
                                            : Colors.grey[400],
                                    label: Text(formattedDate))),
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) => Center(
                      child: Text(error.toString()),
                    ),
                    loading: () => Center(
                      child: loader(),
                    ),
                  ),
            ),
            blockSpacing,
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: activitiesController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Activities Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: startTimeController,
                onTap: () => _showStartTimePicker(),
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timelapse_sharp),
                  labelText: 'Start Time',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onTap: () => _showEndTimePicker(),
                controller: endTimeController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timelapse_sharp),
                  labelText: 'End Time',
                ),
              ),
            ),
            blockSpacing,
            isLoading
                ? Center(
                    child: loader(),
                  )
                : Center(
                    child: ConfirmButton(
                      onTap: () {
                        ref
                            .watch(plannerControllerProvider.notifier)
                            .addActivites(
                              ref: ref,
                              plannedDaysId: selectedDay!.day_id!,
                              tripId: widget.tripId,
                              place: activitiesController.text,
                              startTime: DateTime(
                                  selectedDay!.day_date.year,
                                  selectedDay!.day_date.month,
                                  selectedDay!.day_date.day,
                                  startTime.hour,
                                  startTime.minute),
                              context: context,
                              endTime: DateTime(
                                  selectedDay!.day_date.year,
                                  selectedDay!.day_date.month,
                                  selectedDay!.day_date.day,
                                  endTime.hour,
                                  endTime.minute),
                            );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
