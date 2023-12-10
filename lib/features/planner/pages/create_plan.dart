import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/constants/spacings.dart';

class CreateTrip extends ConsumerStatefulWidget {
  const CreateTrip({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePlanState();
}

class _CreatePlanState extends ConsumerState<CreateTrip> {
  TextEditingController itineraryNameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Trip"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8.0).copyWith(left: 10),
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
              Center(
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_photo_alternate_sharp,
                      size: 200,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: itineraryNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Itinerary Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: placeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Where are you going',
                    hintText: "(Japan, Germany)",
                    hintStyle: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Start Date',
                    prefixIcon: Icon(Icons.date_range),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'End Date',
                    prefixIcon: Icon(Icons.date_range),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
