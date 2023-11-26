// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phraso/core/helper/async_value_helper.dart';
import 'package:phraso/features/phrases/controller/phrases_controller.dart';
import 'package:phraso/features/phrases/widgets/phrases_tile.dart';
import 'package:phraso/models/favouriteModel.dart';
import '../../../core/common/curtom_back_button.dart';

class FavouritePhrasePage extends ConsumerWidget {
  final String langName;
  final String langId;
  const FavouritePhrasePage({
    super.key,
    required this.langName,
    required this.langId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        centerTitle: true,
        leading: const CustomBackButton(),
        backgroundColor: const Color(0xffe63946),
        title: Column(
          children: [
            const Text(
              "Favourites",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "in $langName",
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
      ),
      body: AsyncValueWidget(
        value: ref.watch(getFavourtiesProvider(langId)),
        data: (favourites) {
          print(favourites);
          if (favourites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No favourited $langName phrase"),
                  TextButton(
                      onPressed: () => context.pop(),
                      child: const Text("Go on! favourite some phrases"))
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                final FavouriteModel favourite = favourites[index];
                return PhraseTile(phrasesModel: favourite.phrases!);
              },
            );
          }
        },
      ),
    );
  }
}
