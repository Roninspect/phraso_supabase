// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/common/curtom_back_button.dart';
import 'package:phraso/core/common/loader.dart';
import 'package:phraso/features/phrases/widgets/phrases_tile.dart';
import 'package:phraso/models/top_model.dart';
import '../../../models/double_argsModel.dart';
import '../controller/phrases_controller.dart';

class PhrasesPage extends ConsumerWidget {
  final String nameOfType;
  final TypesOfPhrasesmodel typesOfPhrasesmodel;
  final String languageName;
  final String langId;
  const PhrasesPage({
    super.key,
    required this.nameOfType,
    required this.typesOfPhrasesmodel,
    required this.languageName,
    required this.langId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 3.0,
          ),
        ),
        leading: const CustomBackButton(),
        backgroundColor: Color(int.parse(typesOfPhrasesmodel.color)),
        toolbarHeight: 100,
        title: Column(
          children: [
            Text(nameOfType),
            Text(
              "in $languageName",
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
      body: ref
          .watch(getPhrasesByIdsProvider(
              ArgsModel(langId: langId, typeId: typesOfPhrasesmodel.id)))
          .when(
            data: (data) {
              if (data.isNotEmpty) {
                if (kDebugMode) {
                  print(data);
                }
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final phrase = data[index];
                    return PhraseTile(phrasesModel: phrase);
                  },
                );
              } else { 
                return const Center(
                  child: Text("Coming soon"),
                );
              }
            },
            loading: () => Center(
              child: loader(),
            ),
            error: (error, stackTrace) {
              return Center(
                child: Text(
                  error.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.red),
                ),
              );
            },
          ),
    );
  }
}
