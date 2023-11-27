import 'package:flutter_riverpod/flutter_riverpod.dart';

final phraseSearchQueryNotifierProvider =
    NotifierProvider<PhraseSearchQueryNotifier, String>(
        PhraseSearchQueryNotifier.new);

class PhraseSearchQueryNotifier extends Notifier<String> {
  @override
  build() {
    return "";
  }

  void inputQuery({required String query}) {
    state = query;
  }
}
