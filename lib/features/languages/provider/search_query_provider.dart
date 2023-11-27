import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryNotifierProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  build() {
    return "";
  }

  void inputQuery({required String query}) {
    state = query;
  }
}
