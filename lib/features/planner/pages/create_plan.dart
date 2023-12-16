import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phraso/core/colors/colors.dart';
import 'package:phraso/core/common/curtom_back_button.dart';
import 'package:phraso/core/common/custom_snackbar.dart';
import 'package:phraso/core/common/loader.dart';
import 'package:phraso/core/constants/spacings.dart';
import 'package:phraso/core/helper/pick_image.dart';
import 'package:phraso/features/planner/controller/planner_controller.dart';
import 'package:phraso/features/planner/repository/planner_repository.dart';
import 'package:phraso/features/planner/widgets/confirm_BTN.dart';

class CreateTrip extends ConsumerStatefulWidget {
  const CreateTrip({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePlanState();
}

class _CreatePlanState extends ConsumerState<CreateTrip> {
  TextEditingController itineraryNameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  XFile? image;

  Future<void> selectImage() async {
    try {
      final selectedImage = await pickImage();

      setState(() {
        image = selectedImage;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> selectStartDate() async {
    final _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    setState(() {
      startDate = _picked;
      startDateController.text = _picked.toString().split(" ")[0];
    });
  }

  Future<void> selectEndDate() async {
    if (startDate != null) {
      final _picked = await showDatePicker(
        context: context,
        initialDate: startDate!,
        firstDate: startDate!,
        lastDate: DateTime(2100),
      );

      setState(() {
        endDate = _picked;
        endDateController.text = _picked.toString().split(" ")[0];
      });
    } else {
      showSnackbar(context: context, text: "Please Select Start Date first");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(plannerControllerProvider);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
         automaticallyImplyLeading: false,
            leading: const CustomBackButton(),
        backgroundColor: yellowColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 3.0,
          ),
        ),
        title: const Text("Create a Trip"),
        centerTitle: true,
      ),
      body: isLoading
          ? loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0)
                    .copyWith(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    blockSpacing,
                    const Row(
                      children: [
                        Text(
                          "Add a Photo",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          " (optional)",
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                    image != null
                        ? Center(
                            child: Image.file(
                              File(image!.path),
                            ),
                          )
                        : Center(
                            child: IconButton(
                                onPressed: () {
                                  selectImage();
                                },
                                icon: const Icon(
                                  Icons.add_photo_alternate_sharp,
                                  size: 200,
                                )),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: itineraryNameController,
                         maxLength: 18,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Itinerary Name',
                          hintText: "Trip to Paris...",
                          
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: placeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Travelling to...',
                          hintText: "(Japan, Germany)",
                          hintStyle: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: startDateController,
                        readOnly: true,
                        onTap: () {
                          selectStartDate();
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Start Date',
                          prefixIcon: Icon(Icons.date_range),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: endDateController,
                        readOnly: true,
                        onTap: () {
                          selectEndDate();
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'End Date',
                          prefixIcon: Icon(Icons.date_range),
                        ),
                      ),
                    ),
                    smallSpacing,
                    Center(
                      child: ConfirmButton(
                        onTap: () async {
                          if (itineraryNameController.text.isNotEmpty &&
                              placeController.text.isNotEmpty &&
                              startDate != null &&
                              endDate != null) {
                            await ref
                                .read(plannerControllerProvider.notifier)
                                .createPlan(
                                    tripName: itineraryNameController.text,
                                    placeName: placeController.text,
                                    context: context,
                                    image: image,
                                    startTime: startDate!,
                                    endTime: endDate!);

                            ref.invalidate(getTripsProvider);
                          } else {
                            showSnackbar(
                                context: context,
                                text: "Please Fill all Field");
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
