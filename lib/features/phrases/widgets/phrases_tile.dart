// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phraso/features/phrases/widgets/fav_button.dart';
import 'package:phraso/features/phrases/widgets/play_button.dart';

import 'package:phraso/models/phrases_model.dart';

class PhraseTile extends ConsumerWidget {
  final PhrasesModel phrasesModel;

  const PhraseTile({
    Key? key,
    required this.phrasesModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
            color: Color(int.parse(phrasesModel.color)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(2, 2))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phrasesModel.translatedPhrases,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                Text(
                  '~ ${phrasesModel.pronunciation}',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  phrasesModel.englishPhrases,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: PlayButton(phrasesModel: phrasesModel),
                ),
                const SizedBox(height: 15),

                //** Favourite Button */
                FavButton(phrasesModel: phrasesModel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
