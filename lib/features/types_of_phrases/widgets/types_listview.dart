// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/features/phrases/pages/phrases_page.dart';
import '../../../core/helper/async_value_helper.dart';
import '../controller/top_controller.dart';

class TypesListView extends ConsumerWidget {
  final String languageName;
  final String langId;
  const TypesListView({
    super.key,
    required this.languageName,
    required this.langId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: AsyncValueWidget(
        value: ref.watch(getTypesofPhrasesListProvider),
        data: (types) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: types.length,
            itemBuilder: (context, index) {
              final type = types[index];
              final iconCode = type.icon.startsWith("U+")
                  ? int.parse(type.icon.substring(2), radix: 16)
                  : int.parse(type.icon, radix: 10);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0)
                    .copyWith(bottom: 10),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PhrasesPage(
                        langId: langId,
                        nameOfType: type.name,
                        typesOfPhrasesmodel: type,
                        languageName: languageName,
                      ),
                    ));
                  },
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  leading:
                      Icon(IconData(iconCode, fontFamily: 'MaterialIcons')),
                  tileColor: Color(int.parse(type.color)),
                  title: Text(type.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
