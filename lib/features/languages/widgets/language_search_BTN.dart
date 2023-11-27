import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phraso/router/router.dart';

class LanguageSearchButton extends ConsumerStatefulWidget {
  const LanguageSearchButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LanguageSearchButtonState();
}

class _LanguageSearchButtonState extends ConsumerState<LanguageSearchButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        onTap: () => context.pushNamed(AppRoutes.languageSearch.name),
        readOnly: true,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "Search Preferred language",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
